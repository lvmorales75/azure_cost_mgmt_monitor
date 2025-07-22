#!/bin/bash
# Login to Azure
#az login
echo "Login in az"
az ad sp create-for-rbac \
	--name "$FINOPS_FOCUS_APP_NAME" \
	--role "$FINOPS_FOCUS_APP_ROLE" \
	--scopes /subscriptions/"$AZURE_SUBSCRIPTION_ID"
echo "... account logged."

# Select a subscription to monitor with a budget
az account set --subscription "$AZURE_SUBSCRIPTION_ID"

echo "command: az monitor action-group create \
            --action-group-name $AZURE_ACTION_GROUP_NAME \
            --short-name $AZURE_ACTION_SHORT_NAME \
            --email-receivers "$AZURE_ACTION_GROUP_EMAIL" \
            --resource-group $AZURE_RESOURCE_GROUP \
            --tags $AZURE_ACTION_GROUP_TAGS \
            --query id \
            --output tsv"
# Create an action group with email receiver
ActionGroupId=$(az monitor action-group create \
            --action-group-name $AZURE_ACTION_GROUP_NAME \
            --short-name $AZURE_ACTION_SHORT_NAME \
            --email-receivers "$AZURE_ACTION_GROUP_EMAIL" \
            --resource-group $AZURE_RESOURCE_GROUP \
            --tags $AZURE_ACTION_GROUP_TAGS \
            --query id \
            --output tsv)
echo "Action Group created with ID: $ActionGroupId"

# Receiver is already enabled when created with the action group
echo "Receiver was created with the action group - no need to enable separately"


# Create a monthly budget that sends an email and triggers an Action Group to send a second email.
# Make sure the StartDate for your monthly budget is set to the first day of the current month.
# Note that Action Groups can also be used to trigger automation such as Azure Functions or Webhooks.
echo "command: az consumption budget create \
            --amount $AZURE_BUDGET_AMOUNT \
            --budget-name $AZURE_BUDGET_NAME \
            --category $AZURE_BUDGET_CATEGORY \            
            --start-date $AZURE_BUDGET_START_DATE \
            --end-date $AZURE_BUDGET_END_DATE \
            --time-grain $AZURE_BUDGET_TIME_GRAIN \
            --resource-group $AZURE_RESOURCE_GROUP"

echo "Creating budget..."
az consumption budget create \
    --amount $AZURE_BUDGET_AMOUNT \
    --budget-name $AZURE_BUDGET_NAME \
    --category $AZURE_BUDGET_CATEGORY \
    --start-date $AZURE_BUDGET_START_DATE \
    --end-date $AZURE_BUDGET_END_DATE \
    --time-grain $AZURE_BUDGET_TIME_GRAIN \
    --resource-group $AZURE_RESOURCE_GROUP

echo "Budget created with ID: $AZURE_BUDGET_NAME"
echo "Budget creation completed with Action Group ID: $ActionGroupId"

# Display the created budget details
az consumption budget show \
    --budget-name "$AZURE_BUDGET_NAME" \
    --resource-group "$AZURE_RESOURCE_GROUP" \
    --output table
