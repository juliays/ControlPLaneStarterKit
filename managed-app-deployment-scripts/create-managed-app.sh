# Define and create a managed application
if [ $# -lt 1 ]; then
 echo "usage is: create-managed-app.sh <scale unit name>"
 exit 1
fi

# Variable block
location="East US"
appDefinitionResourceGroup="managed-scaled-unit-app-definition-rg"
appResourceGroup="rg-Managed-ScaleUnit"
tag="create-managed-application"
managedApp="Managed-Scale-Unit"
scaleUnitName=$1

# Create managed application

# Create application resource group
echo "Creating $appResourceGroup in "$location"..."
az group create --name $appResourceGroup --location "$location" --tags $tag

# Get ID of managed application definition
appid=$(az managedapp definition show --name $managedApp --resource-group $appDefinitionResourceGroup --query id --output tsv | tr -d $'\r')

# Get subscription ID. [Last part needed if you are running on WSL]
subid=$(az account show --query id --output tsv | tr -d $'\r')

# Construct the ID of the managed resource group
managedGroupId="/subscriptions/${subid}/resourceGroups/${appResourceGroup}-${scaleUnitName}"
definitionId="/subscriptions/${subid}/resourceGroups/${appDefinitionResourceGroup}/providers/Microsoft.Solutions/applicationDefinitions/${managedApp}"

# Create the managed application
az managedapp create -n $scaleUnitName \
                     -l "$location" \
                     --kind Servicecatalog \
                     -g $appResourceGroup \
                     -d $definitionId \
                     -m $managedGroupId \
                     --parameters "{\"scaleUnitName\": {\"value\": \"$scaleUnitName\"}, \"location\": {\"value\": \"eastus\"}, \"terraformDeploymentFile\": {\"value\": \"https://poccontrolplane.blob.core.windows.net/deployment-tf/application-scale-unit.zip\"}, \"terraformFolder\": {\"value\": \"scale_unit\"}, \"storageAccountName\": {\"value\": \"poccontrolplane\"}, \"functionPackageBlobUrl\": {\"value\": \"https://poccontrolplane.blob.core.windows.net/blob-function-zip/blob-function-1.0-2023-05-04T23_45_13.767Z.zip\"}, \"logAnalyticsWorkspaceId\": {\"value\": \"/subscriptions/f05811b2-7cce-497c-b2dc-d25305b0da86/resourceGroups/rg-ys/providers/Microsoft.OperationalInsights/workspaces/laws-control-plane\"}}"
