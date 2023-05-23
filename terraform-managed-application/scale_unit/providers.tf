terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 3.0.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~>3.0"
    }
  }
}

provider "azurerm" {
  features {
    resource_group {
      # This flag is set to mitigate an open bug in Terraform (https://github.com/hashicorp/terraform-provider-azurerm/issues/18026). 
      # As soon as this is fixed, we should remove this.
      prevent_deletion_if_contains_resources = false
    }
  }
}
