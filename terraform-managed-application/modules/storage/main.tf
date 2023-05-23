# Create storage account for boot diagnostics
resource "azurerm_storage_account" "storage" {
  name                     = var.storage-account-name
  resource_group_name      = var.resource-group-name
  location                 = var.azure-region
  account_tier             = var.storage-account-tier
  account_replication_type = var.storage-account-replication-type

  tags = {
    environment = var.tag
  }
}

resource "azurerm_storage_container" "storage-container" {
  for_each              = toset(var.containers)
  name                  = each.key
  storage_account_name  = azurerm_storage_account.storage.name
  container_access_type = var.container-access-type

  depends_on = [
    azurerm_storage_account.storage
  ]
}

