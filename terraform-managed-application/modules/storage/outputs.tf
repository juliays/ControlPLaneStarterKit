output "name" {
  value       = azurerm_storage_account.storage.name
  description = "The name of the created storage account."
}

output "id" {
  value       = azurerm_storage_account.storage.id
  description = "The id for the storage account."
}

output "primary-key" {
  value       = azurerm_storage_account.storage.primary_access_key
  description = "The primary access key of the created storage account."
}

output "connection-string" {
  value       = azurerm_storage_account.storage.primary_connection_string
  description = "A connection string for the storage account."
}

output "blob-endpoint" {
  value       = azurerm_storage_account.storage.primary_blob_endpoint
  description = "The URL for the blob container."
}
