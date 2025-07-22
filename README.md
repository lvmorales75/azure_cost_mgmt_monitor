# Azure Cost Management Monitor

## Overview
Azure Cost Management Monitor is a tool designed to help organizations monitor and manage their Azure cloud spending. It automates the creation of budget alerts and action groups to notify stakeholders when costs exceed predefined thresholds.

## Objective
The main objective of this application is to provide automated cost monitoring for Azure resources, helping organizations to:
- Track cloud spending in real-time
- Receive alerts when costs approach or exceed budget thresholds
- Enable proactive cost management and optimization
- Improve financial governance of cloud resources

## Structure

```
azure_cost_mgmt_monitor/
├── _in_environment_spec/     # Environment variables and configuration
│   └── variables_specs       # Defines all environment variables used by scripts
├── bash/                     # Bash scripts for automation
│   ├── 01.Create_Action_Group_and_Budget.sh  # Creates action groups and budget alerts
│   └── 02.Delete_Action_Group_and_Budget.sh  # Removes action groups and budget alerts
└── README.md                 # Documentation
```

## Features

- **Action Group Creation**: Sets up notification groups to receive alerts
- **Budget Alert Configuration**: Creates budget thresholds and notification rules
- **Email Notifications**: Sends alerts when costs exceed defined thresholds
- **Clean Removal**: Provides scripts to cleanly remove all created resources

## Prerequisites

- Azure CLI installed and configured
- Appropriate Azure permissions (Contributor or Owner role)
- Bash shell environment

## Usage

### Setup

1. Configure environment variables in `_in_environment_spec/variables_specs`
2. Make scripts executable: `chmod +x bash/*.sh`
3. Run the creation script: `./bash/01.Create_Action_Group_and_Budget.sh`

### Cleanup

To remove all created resources:
```bash
./bash/02.Delete_Action_Group_and_Budget.sh
```

## Environment Variables

Key variables that need to be configured:

- `AZURE_SUBSCRIPTION_ID`: Your Azure subscription ID
- `AZURE_RESOURCE_GROUP`: Resource group for the action group
- `AZURE_ACTION_GROUP_NAME`: Name for the action group
- `AZURE_ACTION_GROUP_EMAIL`: Email configuration for notifications
- `AZURE_BUDGET_NAME`: Name of the budget
- `AZURE_BUDGET_AMOUNT`: Budget threshold amount

## Implementation Details

The application uses Azure REST APIs to create and manage budgets and action groups. It leverages the following Azure services:

- **Azure Monitor Action Groups**: For notification routing
- **Azure Consumption Budgets**: For cost threshold monitoring
- **Azure REST API**: For resource management
