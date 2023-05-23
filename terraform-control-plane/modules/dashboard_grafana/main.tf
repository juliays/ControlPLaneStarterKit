data "azurerm_resource_group" "rg" {
  name = var.resource_group_name
}

data "azurerm_resource_group" "control-rg" {
  name = var.control_plane_resource_group_name
}

data "azurerm_log_analytics_workspace" "laws" {
  name = var.laws-name
  resource_group_name =  data.azurerm_resource_group.control-rg.name  
}

# remove comment to run as independent script
# provider "azurerm" {
#   features {}
# }

resource "azapi_resource" "azgrafana" {
  type        = "Microsoft.Dashboard/grafana@2022-08-01"
  name        = var.grafana_name
  parent_id   = data.azurerm_resource_group.rg.id
  location    = var.grafana_account_location
  
  identity {
    type      = "SystemAssigned"
  }

  body = jsonencode({
    sku = {
      name = "Standard"
    }
    properties = {
      publicNetworkAccess = "Enabled",
      zoneRedundancy = "Enabled",
      apiKey = "Enabled",
      deterministicOutboundIP = "Enabled"
    }
  })
  response_export_values = ["identity.principalId"]
}
# assign reader role to log analytics workspace
resource "azurerm_role_assignment" "laws-read-role-assignment" {
  scope =  data.azurerm_log_analytics_workspace.laws.id
  role_definition_name = "Reader"
  principal_id = azapi_resource.azgrafana.identity[0].principal_id
} 
# optional to automate the dashboard import process
# resource "null_resource" "aca" {
#   provisioner "local-exec" {
#     command = <<-EOT
#         az config set extension.use_dynamic_install=yes_without_prompt
#         echo 'config is done'

#         set -ex
#         if [ -n "$ARM_CLIENT_ID" ]; then
#           # We are running on an Azure DevOps agent, need to log in
#           echo 'login'
#           az login --service-principal \
#             --username $ARM_CLIENT_ID \
#             --password $ARM_CLIENT_SECRET \
#             --tenant $ARM_TENANT_ID \
#             --output none
#         fi
#         az grafana dashboard create -g ${var.resource_group_name} \
#           -n ${azapi_resource.azgrafana.name} \
#           --definition ${var.grafana_json_location}
#         echo 'import is done'
#     EOT
#     interpreter = ["/bin/bash", "-c"]
#     working_dir = path.module
#   }
#}
