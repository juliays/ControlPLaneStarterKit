output "name" {
  value       = azurerm_linux_function_app.function-app.name
  description = "The name of the created function app."
}

output "id" {
  value       = azurerm_linux_function_app.function-app.id
  description = "The id of the created function app."
}
