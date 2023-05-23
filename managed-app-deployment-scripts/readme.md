# Managed Scale Unit as an Azure Managed Application

This folder represents the scaled unit as [envisioned](../../docs/initial-unit-defintion.md) an Azure Managed Application.

## Pre-requisites

You must have a managed identity (deployment_controller) in ControlPlanePOC resource group to run the managed application as. If you look at the [create-managed-create-managed-app-definition script](./create-managed-create-managed-app-definition.sh) on lines 17-19, you can see get a managed id, a service principle - "ControlPlaneSP" (we used in pipelines), and group (we put our developer team in). We then use these on line 25 in the _--authorization_ parameter to set security for the managed application and managed resource groups it creates.

Assign "Contributor" to this user managed identify "deployment_controller" to your subscription so it can provision resources and modify settings.

## Structure of an Azure Managed Application

An Azure Managed application consists of the following files:

1. [createUiDefinition.json](./managed-scale-unit/createUiDefinition.json)
2. [mainTemplate.json](./managed-scale-unit/mainTemplate.json)
3. [viewDefinition.json](./managed-scale-unit/viewDefinition.json) __NOTE:__ This file is optional
4. [nestedTemplates folder](./managed-scale-unit/nestedtemplates/). Inside this folder is the ARM template to deploy the application. 

All of these files are detailed [here](https://learn.microsoft.com/en-us/azure/azure-resource-manager/managed-applications/publish-service-catalog-app?tabs=azure-powershell).

## Updating and deploying

1. Change files that are necessary for your Managed Application needs.
2. Run the [refresh script](./refresh-zipfiles.sh).
3. Upload the [zip file](./managed-scale-unit/managedScaleUnit.zip) to your storage container of choice (**NOTE:** make sure the script to create it matches on line 24 in [create-managed-app-definition.sh](./create-managed-app-definition.sh)).
4. Run [script](./create-managed-create-managed-app-definition.sh) to create the managed app
5. Subsequently run [script](./create-managed-app.sh) to create scale units

__NOTES:__

The container referenced in Step 3 above must be an anonymously accessible container so the identity of the managed application can reach it to download.

 Use "create-managed-app.sh [scaleunitname]" to create scale unit using the script. Update the zip location for both terraform script and azure function app.

scaleunitname - can only have lowercase letters and numbers and can't be too long. It needs to accept a suffix and still not exceed 24 char limit because of the storage account that will be created. 