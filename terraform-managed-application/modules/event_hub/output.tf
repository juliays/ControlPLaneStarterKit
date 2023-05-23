output "namespace-name" {
  value       = azurerm_eventhub_namespace.ehn.name
  description = "The name of the created eventhub namespace."
}

output "namespace-id" {
  value       = azurerm_eventhub_namespace.ehn.id
  description = "The id of the created eventhub namespace."
}

output "eventhub-name" {
  value       = azurerm_eventhub.eh.name
  description = "The name of the created eventhub."
}

output "connection-string" {
  value       = azurerm_eventhub_authorization_rule.ehar.primary_connection_string
  description = "A connection string for the eventhub namespace."
}
