import List "mo:base/List";
import Text "mo:base/Text";
import Time "mo:base/Time";
import Debug "mo:base/Debug";
import Nat "mo:base/Nat";

actor WorkflowEngine {

    // Data Types
    type Trigger = {
        id: Nat;
        wallet: Text;            // Wallet address to monitor
        condition: Text;         // Condition, e.g., "balance > 100"
        createdAt: Time.Time;    // Timestamp of trigger creation
    };

    type Workflow = {
        id: Nat;                 // Unique ID for the workflow
        triggerId: Nat;          // Trigger linked to the workflow
        action: Text;            // Action to execute, e.g., "send_tokens"
    };

    type Logs = {
        workflowId: Nat;
        executedAt: Time.Time;
    };

    // Stable Variables
    stable var triggers: List.List<Trigger> = List.nil<Trigger>();
    stable var workflows: List.List<Workflow> = List.nil<Workflow>();
    stable var logs: List.List<Logs> = List.nil<Logs>();

    // Public Functions

    // Register a new trigger
    public func addTrigger(wallet: Text, condition: Text): async Text {
        let newTrigger: Trigger = {
            id = List.size(triggers) + 1;
            wallet = wallet;
            condition = condition;
            createdAt = Time.now();
        };
        triggers := List.push(newTrigger, triggers);
        return "Trigger added successfully!";
    };

    // Create a new workflow by linking a trigger to an action
    public func createWorkflow(triggerId: Nat, action: Text): async Text {
        let trigger = List.find(triggers, func(t: Trigger): Bool { t.id == triggerId });
        if (trigger == null) {
            return "Invalid trigger index!";
        };
        let workflow: Workflow = {
            id = List.size(workflows) + 1;
            triggerId = triggerId;
            action = action;
        };
        workflows := List.push(workflow, workflows);
        return "Workflow created successfully!";
    };

    // Check usage analytics
    public func checkUsage(): async {workflows: Nat; triggers: Nat; logs: Nat} {
        return {
            workflows = List.size(workflows);
            triggers = List.size(triggers);
            logs = List.size(logs);
        };
    };

    // Private Functions

    // Simulated notification logic
    private func sendNotification(wallet: Text, message: Text): async Text {
        Debug.print("Notification to " # wallet # ": " # message);
        return "Notification sent to " # wallet;
    };

    private func transferTokens(wallet: Text, amount: Nat): async Text {
        Debug.print("Transferring " # Nat.toText(amount) # " tokens to " # wallet);
        return "Transferred " # Nat.toText(amount) # " tokens to " # wallet;
    };

    // Evaluate if a trigger condition is met
    private func evaluateTrigger(triggerId: Nat): async Bool {
        let triggerOpt = List.find(triggers, func(t: Trigger): Bool { t.id == triggerId });
        switch triggerOpt {
            case (?trigger) {
                if (trigger.condition == "balance > 100") {
                    return true; // Replace with actual balance logic
                };
                return false;
            };
            case null {
                return false;
            };
        };
    };

    // Execute an action
    private func executeAction(action: Text, wallet: Text): async Text {
        switch (action) {
            case ("send_tokens") {
                return await transferTokens(wallet, 100); // Example: transfer 100 tokens
            };
            case ("notify_user") {
                return await sendNotification(wallet, "Trigger condition met!");
            };
            case _ {
                return "Unknown action type!";
            };
        };
    };

    // Log workflow execution
    private func logExecution(workflowId: Nat): async () {
        let logEntry = {workflowId; executedAt = Time.now()};
        logs := List.push(logEntry, logs);
    };

    // Periodically check and execute workflows
    public func checkAndExecuteWorkflows(): async () {
        var remainingWorkflows = workflows; // Create a mutable copy of workflows
        while (List.isNil(remainingWorkflows)== false) {
            let headAndTail = List.pop(remainingWorkflows);
            switch headAndTail {
                case (?workflow, rest) {
                    remainingWorkflows := rest;
                    let triggerOpt = List.find(triggers, func(t: Trigger): Bool { t.id == workflow.triggerId });
                    switch triggerOpt {
                        case (?trigger) {
                            let isTriggered = await evaluateTrigger(workflow.triggerId);
                            if (isTriggered) {
                                let result = await executeAction(workflow.action, trigger.wallet);
                                await logExecution(workflow.id);
                                Debug.print("Workflow #" # Nat.toText(workflow.id) # ": " # result);
                            };
                        };
                        case null {
                            Debug.print("Trigger not found for Workflow #" #  Nat.toText(workflow.id));
                        };
                    };
                };
                case (null, _) {
                    Debug.print("No more workflows to process.");
                };
            };
        };
    };
};