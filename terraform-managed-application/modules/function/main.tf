resource "azurerm_service_plan" "service-plan" {
  name                = var.service-plan-name
  resource_group_name = var.resource-group-name
  location            = var.azure-region
  os_type             = var.os-type
  sku_name            = var.sku
}

resource "azurerm_linux_function_app" "function-app" {
  name                = var.function-app-name
  resource_group_name = var.resource-group-name
  location            = var.azure-region

  storage_account_name       = var.storage-account-name
  storage_account_access_key = var.storage-account-access-key
  service_plan_id            = azurerm_service_plan.service-plan.id
  builtin_logging_enabled    = false

  app_settings = merge(
    var.app-settings,
    { "WEBSITE_RUN_FROM_PACKAGE" : var.blob-package-url },
    { "FUNCTIONS_WORKER_RUNTIME" : var.runtime-language }
  )

  site_config {
    application_insights_key = var.app-insights-key
    application_stack {
      java_version = "11"
    }
  }

  depends_on = [
    azurerm_service_plan.service-plan
  ]
}
