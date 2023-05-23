output "name" {
  value = azurerm_resource_group.rg.name
  description = "The name of the created resource group."
}

output "id" {
  value = azurerm_resource_group.rg.id
  description = "The id of the created resource group."
}
