# Workflow Engine

## Overview
The **Workflow Engine** is a smart contract built in **Motoko** for the **Internet Computer (IC)**. It enables automated monitoring of triggers, execution of workflows based on predefined conditions, and logging of completed actions.

## Features
- **Trigger Management**: Add and monitor triggers based on wallet conditions.
- **Workflow Execution**: Link triggers to specific actions like notifications or token transfers.
- **Logging**: Track executed workflows with timestamps.
- **Analytics**: View the total number of triggers, workflows, and logs.

## Data Types
### Trigger
Represents a condition to monitor.  
```motoko
type Trigger = {
    id: Nat;
    wallet: Text;           // Wallet address to monitor
    condition: Text;        // Condition, e.g., "balance > 100"
    createdAt: Time.Time;   // Timestamp of trigger creation
};
```

### Workflow
Defines an action to execute when a trigger is met.  
```motoko
type Workflow = {
    id: Nat;                // Unique ID for the workflow
    triggerId: Nat;         // Trigger linked to the workflow
    action: Text;           // Action to execute, e.g., "send_tokens"
};
```

### Logs
Logs details of workflow execution.  
```motoko
type Logs = {
    workflowId: Nat;
    executedAt: Time.Time;
};
```

## Key Functions
1. **addTrigger**: Add a new trigger.
2. **createWorkflow**: Create a workflow linked to a trigger.
3. **checkUsage**: Retrieve usage statistics.
4. **checkAndExecuteWorkflows**: Periodically evaluate workflows, execute actions, and log results.

## Installation and Usage
1. Clone this repository:
   ```bash
   git clone [<repository-url>](https://github.com/Tonyflam/decentralized_workflow_automation_engine.git)
   ```
2. Deploy the `WorkflowEngine` actor to your Internet Computer project.
3. Interact with the canister using a suitable interface like `dfx` or a frontend application.

## Example Usage
### Add a Trigger
```motoko
await WorkflowEngine.addTrigger("wallet-address", "balance > 100");
```

### Create a Workflow
```motoko
await WorkflowEngine.createWorkflow(1, "send_tokens");
```

### Check Usage
```motoko
await WorkflowEngine.checkUsage();
```

### Execute Workflows
```motoko
await WorkflowEngine.checkAndExecuteWorkflows();
```

## License
This project is open-sourced under the MIT License. 

For questions or contributions, feel free to submit an issue or pull request! 🚀
