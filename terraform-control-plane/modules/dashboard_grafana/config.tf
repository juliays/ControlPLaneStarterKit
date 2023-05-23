terraform {
  required_providers {
    azapi = {
      source = "Azure/azapi"
      version = ">=1.0.0"
    }
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>3.34"
    }
    azuread = {
      source  = "hashicorp/azuread"
      version = "~>2.31"
    }
  }
}