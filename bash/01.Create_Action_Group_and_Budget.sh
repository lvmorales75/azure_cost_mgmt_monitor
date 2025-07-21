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

# Create an action group email receiver and corresponding action group
vemail=$(az monitor action-group receiver email create \
	        --email-address $AZURE_ACTION_GROUP_EMAIL \
            --name $AZURE_ACTION_GROUP_EMAIL_RECIEVER_NAME \
            --resource-group $AZURE_ACTION_GROUP_RG \
            --query id \
            --output tsv)
echo "Email receiver created with ID: $vemail"            
ActionGroupId=$(az monitor action-group create \
            --resource-group $AZURE_ACTION_GROUP_RG \
            --name $AZURE_ACTION_TAG_NAME \
            --short-name $AZURE_ACTION_SHORT_NAME \
            --receiver "$vemail" \
            --query id \
            --output tsv) 
echo "Action Group created with ID: $ActionGroupId"
 
 # Create a monthly budget that sends an email and triggers an Action Group to send a second email.
# Make sure the StartDate for your monthly budget is set to the first day of the current month.
# Note that Action Groups can also be used to trigger automation such as Azure Functions or Webhooks.
 az consumption budget create-with-rg \
    --amount $AZURE_BUDGET_AMOUNT \
    --budget-name $AZURE_BUDGET_NAME \
    -g $rg \
    --category $AZURE_BUDGET_CATEGORY \ 
    --time-grain $AZURE_BUDGET_TIME_GRAIN \ 
    --time-period "{\"start-date\":\"$AZURE_BUDGET_START_DATE\",\"end-date\":\"$AZURE_BUDGET_END_DATE\"}" \
    --notifications "{\"$AZURE_BUDGET_NOTIFICATION_KEY\":{\"enabled\":\"$AZURE_BUDGET_NOTIFICATION_ENABLED\", \"operator\":\"$AZURE_BUDGET_NOTIFICATION_OPERATOR\", \"contact-emails\":[],  \"threshold\":$AZURE_BUDGET_NOTIFICATION_THRESHOLD, \"contact-groups\":[\"$ActionGroupId\"]}}"
echo "Budget created with ID: $AZURE_BUDGET_NAME"
echo "Budget creation completed with Action Group ID: $ActionGroupId"
# Display the created budget details
az consumption budget show --name "$AZURE_BUDGET_NAME" --resource-group "$AZURE_RESOURCE_GROUP" --output table


