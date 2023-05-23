# Control Plane Terraform

This folder contains all tha tis needed to provision the control plane using Terraform run either locally or through the pipeline scripts in the [pipeline](../pipelines/) folder.

## Running in Azure

The way this is run in Azure is to use either the [provision-control-plane](../../pipelines/provision-control-plane.yml) pipeline or the [deprovision-control-plane](../../pipelines/deprovision-control-plane.yml) pipeline. As their names imply, these will either provision or deprovision the control plane in Azure. You still must perform the [pre-work](#important-pre-work-that-must-happen-first) below.

## Running locally

You may run this locally as well. You still must perform the [pre-work](#important-pre-work-that-must-happen-first) below. Once completed, you can simply run the below:

```bash
# log into an account that has the ability to provision into Azure
az login

# pick the account to use
az account set -s <subscriptionid>

# init terraform
terraform init

# deploy
terraform deploy

# when ready remove resource
terraform destroy
```

## **IMPORTANT** Pre-work that must happen first

There is a step that must be accomplished before the above can happen. Terraform requires a state file to be created, stored, and manipulated throughout the deployment lifecycle. In Azure, this must exist before things can be run. For this, we have created a [script](./azure-state.sh) that must be used in the below:

```bash
# log into an account that has the ability to provision into Azure
az login

# pick the account to use
az account set -s <subscriptionid>

# create service principle and record info. Add these as variables to the pipeline
az ad sp create-for-rbac --name <name>
```
