variable "service-plan-name" {
  type        = string
  description = "The nane for the new service plan."
}

variable "function-app-name" {
  type        = string
  description = "The the name for the new function app."
}

variable "azure-region" {
  type        = string
  description = "The Azure region that items should be provisioned in."
}

variable "resource-group-name" {
  type        = string
  description = "The resource group where these resources will be provisioned."
}

variable "storage-account-name" {
  type        = string
  description = "The name of the storage account that contains the zip deploy file."
}

variable "storage-account-access-key" {
  type        = string
  description = "The access key of the storage account that contains the zip deploy file."
}

variable "blob-package-url" {
  type        = string
  description = "The URL to the blob that contains the zip deploy file."
}

variable "os-type" {
  type        = string
  description = "The operating system that the service plan runs on."
}

variable "runtime-language" {
  type        = string
  description = "The runtime language that the function will run in."
}

variable "app-insights-key" {
  type        = string
  description = "The Application Insights instrumentation key."
}

variable "app-settings" {
  type = map(string)
}

variable "sku" {
  type        = string
  default     = "Y1"
  description = "The service plan SKU that will be created."
}
