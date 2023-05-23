variable "name-prefix" {
  type        = string
  description = "Unique name to be pre-pended to all resources created."
}

variable "resource-group" {
  type        = string
  description = "The resource group that all resources will be created in."
}

variable "blob-package-url" {
  type        = string
  description = "The URL to the blob that contains the zip deploy file."
}

variable "log-analytics-workspace-id" {
  type        = string
  description = "The id for the log analytics workspace that all logs and metrics will be routed to."
}

variable "azure-region" {
  type        = string
  description = "Location of the resource group."
}
