variable "resource-group-name" {
  type        = string
  description = "The resource group where these resources will be provisioned."
}

variable "azure-region" {
  type        = string
  description = "The Azure region that items should be provisioned in."
}

variable "tag" {
  type        = string
  default     = ""
  description = "An optional tag value to be put on the resource."
}