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
            --query id \
            --output tsv"
# Create an action group with email receiver
ActionGroupId=$(az monitor action-group create \
            --action-group-name $AZURE_ACTION_GROUP_NAME \
            --short-name $AZURE_ACTION_SHORT_NAME \
            --email-receivers "$AZURE_ACTION_GROUP_EMAIL" \
            --resource-group $AZURE_RESOURCE_GROUP \
            --query id \
            --output tsv)
echo "Action Group created with ID: $ActionGroupId"

# Add receiver to the action group
echo "command: az monitor action-group enable-receiver \
            --receiver-name $AZURE_ACTION_GROUP_EMAIL_RECEIVER_NAME \
            --resource-group $AZURE_RESOURCE_GROUP \
            --action-group-name $AZURE_ACTION_GROUP_NAME"

az monitor action-group enable-receiver \
            --receiver-name $AZURE_ACTION_GROUP_EMAIL_RECEIVER_NAME \
            --resource-group $AZURE_RESOURCE_GROUP \
            --action-group-name $AZURE_ACTION_GROUP_NAME
echo "Receiver added to action group"


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
            --resource-group $AZURE_ACTION_GROUP_RG \

az consumption budget create \
    --amount $AZURE_BUDGET_AMOUNT \
    --budget-name $AZURE_BUDGET_NAME \
    --category $AZURE_BUDGET_CATEGORY \
    --start-date $AZURE_BUDGET_START_DATE \
    --end-date $AZURE_BUDGET_END_DATE \
    --time-grain $AZURE_BUDGET_TIME_GRAIN \
    --resource-group $AZURE_ACTION_GROUP_RG \
echo "Budget created with ID: $AZURE_BUDGET_NAME"
echo "Budget creation completed with Action Group ID: $ActionGroupId"

# Display the created budget details
az consumption budget show 
    --budget-name "$AZURE_BUDGET_NAME" 
    --resource-group "$AZURE_ACTION_GROUP_RG" 
    --output table


