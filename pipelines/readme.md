# Pipelines for the control plane and examples

This directory represents the pipelines that will run in the Azure DevOps. To run these there will need to be some variables in an Azure DevOps library. First off name the Library `control-plane`. Secondly create the following variables in that library:

|Variable|Description
|--------|-----------
|**appid**|**Make protected** The App ID for the service principle
|**location**|The region identifier used in the az cli commands
|**managed_app_container**|The container to write the managed app zip file to
|**name**|**Make protected** Service Principle Name
|**password**|**Make protected** Service Principle password
|**resource_group**|The resource group to place resources in
|**sa_container**|The storage account container
|**sa_name**|The storage account name
|**subscription_id**|The subscription id to work in
|**tenant**|**Make protected** Tenant ID for the Service Principle

## Pipeline descriptions

1. **deprovision-control-plane.yml** - This pipeline will deprovision the control plane but leave the Terraform state file and Azure storage in place
1. **provision-control-plane.yml** - This pipeline will provision the control plane
1. **build-deploy-managed-app.yml** - This pipeline will build and deploy the managed and application when changes are made to vendor/azure (except *.md changes)
