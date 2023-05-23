terraform {
  backend "azurerm" {
  }
}

module "log_analytics_workspace" {
  source = "../modules/log_analytics_workspace"

  resource_group_name               = var.control-plane-resource-group-name
  log_analytics_workspace_location  = var.azure-region
  log_analytics_workspace_name      = var.log_analytics_workspace_name
  log_analytics_workspace_sku       = var.log_analytics_workspace_sku
  log_analytics_workspace_retention = var.log_analytics_workspace_retention
}


module "dashboard_grafana" {
  source = "../modules/dashboard_grafana"

  resource_group_name               = var.control-plane-resource-group-name
  grafana_account_location          = var.azure-region
  grafana_name                      = var.grafana_name
  grafana_json_location             = var.grafana_json_location
  ARM_CLIENT_ID                     = var.ARM_CLIENT_ID
}