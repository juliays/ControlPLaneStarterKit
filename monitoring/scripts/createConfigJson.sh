#!/bin/bash

#This script can be used to collect event hub connection strings for all event hubs created for the managed app.
#It will work for both OSX and 
#It will create the config.json in the same folder this command is at. 
#
#uncomment and  run the az login with service-pricipal to log in to get access to the managed app resource group
#az login --service-principal --username <client-id> --password  <client-password> --tenant <tenant-id>

echo '{"eventHubSettings": []}' > ./config.json
#uncomment to add resource-graph extension if not installed yet
#az extension add --name resource-graph
for result in $(az graph query -q 'Resources | where type == "microsoft.solutions/applications" | where parse_json(properties).applicationDefinitionId contains ("Managed-Scale-Unit") | project p = split(parse_json(properties).managedResourceGroupId,"/")[4] | project ManagedResourceGroup = tolower(substring(p,0)) | join (Resources | where type == "microsoft.eventhub/namespaces" | project ResourceGroup = tolower(resourceGroup), EventhubNS = name) on $left.ManagedResourceGroup == $right.ResourceGroup' | jq --raw-output '.data[]|[.ManagedResourceGroup, .EventhubNS] | join(",")')
do
    IFS=, read -ra arr <<< $result
    if [[ "$OSTYPE" == "darwin"* ]]; then
        declare arrs
        declare j=0
        for i in $arr; do
            arrs[j]=$i
            ((j ++))
        done
        mrg=${arrs[0]}
        ehns=${arrs[1]}
    else
        mrg=${arr[0]}
        ehns=${arr[1]}
    fi            
    ehname=$(az eventhubs eventhub list --resource-group $mrg --namespace-name $ehns --query "[].name" --output tsv | tr -d $'\r')
    ruleName=$(az eventhubs eventhub authorization-rule list --resource-group $mrg --namespace-name $ehns --eventhub-name $ehname --query "[].name" --output tsv | tr -d $'\r')
    connString=$(az eventhubs eventhub authorization-rule keys list --resource-group $mrg --namespace-name $ehns --eventhub-name $ehname --name $ruleName --query "primaryConnectionString" --output tsv | tr -d $'\r')
    echo $(jq --arg ehcs "$connString" --arg ehn "$ehname" '.eventHubSettings += [{"eventHubConnectionString":$ehcs,"eventHubName":$ehn}]' ./config.json) > ./config.json
done