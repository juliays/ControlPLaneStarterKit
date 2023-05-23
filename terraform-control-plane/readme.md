# Terraform Local Run 

## Install Terraform

You will need to install Terraform on your local machine to execute the terraform commands.
[Terraform Getting Started](https://learn.hashicorp.com/tutorials/terraform/install-cli?in=terraform/azure-get-started)

## Install the Azure ClI

You will need to install the Azure CLI.
[Install Azure CLI](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli)


### Log in to Azure

Log into Azure and set the default subscription to deploy to that subscription.

```bash
az login
az account set --subscription "My Subscription"
```


## Terraform Init

Before running the Terraform commands, you need to download the modules that are used. Navigate to eng/terraform/e2e-testing for the below operations

```bash
terraform init
```

If you need to configure your local state with the cloud state, please do the following
```bash
terraform init -reconfigure -backend-config="resource_group_name=<resourcegroupname>"
```

## Terraform State

Terraform keeps its state information blob storage. You can retrieve the file directly from blob storage, or you can use the "state" command to view state information. Terraform needs the key to the storage account which should be assigned to an environmental variable named "ARM_ACCESS_KEY". 

## Terraform Plan

The Terraform plan command looks at the current state and compares it to the required state. If any changes are needed, they are described and can be saved in a file for later execution.

```bash
terraform plan -var-file=./shared-vars/terraform.tfvars -out "test_infra.tfplan"
```

## Terraform Apply

The Terraform apply command will execute the tf scripts to provision the Azure resources. You can use the file created in the "plan" step, but this is optional.

```bash
terraform apply "test_infra.tfplan" -var-file=./shared-vars/terraform.tfvars
```

```bash
terraform apply -var-file=./shared-vars/terraform.tfvars
```

outside of tf we need to grant SP a role to import dashboard. For this purpose we need super user access and assign a
role to SP. Principle must make re-login to get assignment into effect. 
```bash
az role assignment create --assignee $ARM_CLIENT_ID  --role "Grafana Editor" --subscription $ARM_SUBSCRIPTION_ID
```

https://grafana.com/docs/grafana/latest/administration/roles-and-permissions/access-control/manage-rbac-roles/
