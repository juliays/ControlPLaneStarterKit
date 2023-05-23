terraform {
  backend "azurerm" {
  }
}

locals {
  extraSuffix = "ccpoc"
}

module "storage" {
  source = "../modules/storage"

  storage-account-name  = "${var.name-prefix}${local.extraSuffix}storage"
  resource-group-name   = var.resource-group
  azure-region          = var.azure-region
  containers            = ["output"]
  container-access-type = "blob"
}

module "event_hub" {
  source = "../modules/event_hub"

  prefix              = var.name-prefix
  suffix              = local.extraSuffix
  azure-region        = var.azure-region
  resource-group-name = var.resource-group
}

resource "azurerm_application_insights" "app-insights" {
  name                = "${var.name-prefix}-${local.extraSuffix}-ai"
  location            = var.azure-region
  resource_group_name = var.resource-group
  workspace_id        = var.log-analytics-workspace-id
  application_type    = "java"
}

module "function_app" {
  source = "../modules/function"

  azure-region               = var.azure-region
  blob-package-url           = var.blob-package-url
  storage-account-name       = module.storage.name
  storage-account-access-key = module.storage.primary-key
  resource-group-name        = var.resource-group
  service-plan-name          = "${var.name-prefix}-${local.extraSuffix}-app-service-plan"
  function-app-name          = "${var.name-prefix}-${local.extraSuffix}-linux-fa"
  os-type                    = "Linux"
  runtime-language           = "java"
  app-insights-key           = azurerm_application_insights.app-insights.instrumentation_key
  app-settings = {
    "app.config.azure.storage_id"                       = "${module.storage.id}",
    "app.config.azure.storage_endpoint"                 = "${module.storage.blob-endpoint}",
    "app.config.azure.storage.container.blob.output"    = "output",
    "app.config.azure.storage.aggregation.time.seconds" = "30",
    "app.config.azure.eventhub.event_hub_name"          = "${module.event_hub.eventhub-name}",
    "app.config.azure.eventhub.connection_string"       = "${module.event_hub.connection-string}",
    "app.config.azure.storage.connection_string"        = "${module.storage.connection-string}"
  }
}

resource "azurerm_monitor_diagnostic_setting" "diagnostics" {
  for_each = {
    (module.storage.name)             = (module.storage.id),
    (module.event_hub.namespace-name) = (module.event_hub.namespace-id),
    (module.function_app.name)        = (module.function_app.id)
  }
  name                       = "${each.key}-${local.extraSuffix}-diag"
  target_resource_id         = each.value
  log_analytics_workspace_id = var.log-analytics-workspace-id

  metric {
    category = "AllMetrics"

    retention_policy {
      enabled = false
    }
  }
}

