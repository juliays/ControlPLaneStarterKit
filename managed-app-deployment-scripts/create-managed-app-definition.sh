# Define and create a managed application

# Variable block
location="East US"
appDefinitionResourceGroup="managed-scaled-unit-app-definition-rg"
appResourceGroup="rg-Managed-ScaleUnit"
tag="create-managed-application"
managedApp="Managed-Scale-Unit"

# Create definition for a managed application

# Create a application definition resource group
echo "Creating $appDefinitionResourceGroup in "$location"..."
az group create --name $appDefinitionResourceGroup --location "$location" --tags $tag

# Get Azure Active Directory group to manage the application
managedid=$(az ad sp list --filter "displayname eq 'deployment_controller'" --query "[].id" --output tsv)
managedid2=$(az ad sp list --filter "displayname eq 'ControlPlaneSP'" --query "[].id" --output tsv)
principalid=$(az ad group show --group "CSE Viper" --query id --output tsv)

# Get role
roleid=$(az role definition list --name Owner --query [].name --output tsv)

# Create the definition for a managed application
az managedapp definition create --name "$managedApp" --location "$location" --resource-group $appDefinitionResourceGroup --lock-level ReadOnly --display-name "Managed Scale Unit" --description "Managed Scale Unit Account" --authorizations "$managedid:$roleid" "$managedid2:$roleid" "$principalid:$roleid" --package-file-uri "https://poccontrolplane.blob.core.windows.net/managedapp/managedScaleUnit.zip"
#az managedapp definition create --name "$managedApp" --location "$location" --resource-group $appDefinitionResourceGroup --lock-level ReadOnly --display-name "Managed Scale Unit" --description "Managed Scale Unit Account" --authorizations "$managedid:$roleid"  "$managedid2:$roleid" --package-file-uri "https://poccontrolplane.blob.core.windows.net/managedapp/managedScaleUnit.zip"

echo "Updating $managedApp to incremental deployment..."
# NOTE: This whole section is done due to the az cli not allowing you to set the deploymentPolicy on creation
#get newly created app for update
az rest --method get --url /subscriptions/f05811b2-7cce-497c-b2dc-d25305b0da86/resourceGroups/managed-scaled-unit-app-definition-rg/providers/Microsoft.Solutions/applicationDefinitions/Managed-Scale-Unit?api-version=2019-07-01 -o json > managedapp-definition.json
#add packageFileUri property
echo "$(jq '.properties += { "packageFileUri": "https://poccontrolplane.blob.core.windows.net/managedapp/managedScaleUnit.zip"}' managedapp-definition.json)" > managedapp-definition.json
#add deploymentPolicy node
echo "$(jq '.properties += { "deploymentPolicy": { "deploymentMode": "Incremental" } }' managedapp-definition.json)" > managedapp-definition.json
#update managed app for incremental deployment
az rest --method put --url /subscriptions/f05811b2-7cce-497c-b2dc-d25305b0da86/resourceGroups/managed-scaled-unit-app-definition-rg/providers/Microsoft.Solutions/applicationDefinitions/Managed-Scale-Unit?api-version=2019-07-01 --body @managedapp-definition.json -o json
