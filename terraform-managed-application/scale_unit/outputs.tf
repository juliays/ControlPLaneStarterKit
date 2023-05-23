output "storage_account_name" {
  value       = module.storage.name
  description = "The name of the created storage account."
}

output "storage_account_key" {
  value       = module.storage.primary-key
  sensitive   = true
  description = "The primary access key of the created storage account."
}
