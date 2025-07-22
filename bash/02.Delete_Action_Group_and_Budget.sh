#!/bin/bash
# Script to delete Azure Budget and Action Group
#az login
echo "Login in az"
az ad sp create-for-rbac \
	--name "$FINOPS_FOCUS_APP_NAME" \
	--role "$FINOPS_FOCUS_APP_ROLE" \
	--scopes /subscriptions/"$AZURE_SUBSCRIPTION_ID"
echo "... account logged."

# Select the subscription
echo "Selecting subscription..."
az account set --subscription "$AZURE_SUBSCRIPTION_ID"

# Delete the budget
echo "Deleting budget: $AZURE_BUDGET_NAME"
az consumption budget delete \
    --budget-name "$AZURE_BUDGET_NAME" \
    --resource-group "$AZURE_RESOURCE_GROUP"
echo "Budget deleted successfully"

# Delete the action group
echo "Deleting action group: $AZURE_ACTION_GROUP_NAME"
az monitor action-group delete \
    --name "$AZURE_ACTION_GROUP_NAME" \
    --resource-group "$AZURE_RESOURCE_GROUP" \
    --yes
echo "Action group deleted successfully"
