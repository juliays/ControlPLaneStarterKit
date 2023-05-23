# Azure Managed Grafana module

This is the module to set up azure managed grafana. It depends on log analytics workspace being established.

A terrform.tfvars.template is in provided to give some idea on what values it needs to run properly. In the example, log analytics workspace is created in a separate resource group. It could be set up in the same resource group, in which case, you only need one variable for resource group name.

***
Once the terraform script runs, the azure managed grafana instance will be up with the correct log analytics workspace role assignment. You need to use Azure Portal to assign user access "Admin", "Editor", or "Viewer" to the grafana instance for user to gain access.
***

To run the module on its own, uncomment the section below in main.tf.

```
# provider "azurerm" {
#   features {}
# }
```
