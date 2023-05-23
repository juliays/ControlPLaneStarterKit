variable "storage-account-name" {
  type = string
}

variable "resource-group-name" {
  type = string
}

variable "azure-region" {
  type        = string
  description = "The Azure region that items should be provisioned in."
}

variable "storage-account-tier" {
  type        = string
  default     = "Standard"
  description = "The tier that the storage account should be set to."
}

variable "storage-account-replication-type" {
  type        = string
  default     = "LRS"
  description = "The replication type that the storage account should be set to."
}

variable "tag" {
  type        = string
  default     = ""
  description = "Extra tag data for the storage account."
}

variable "containers" {
  type        = list(string)
  description = "The list of container names to be created"
  default     = []
}

variable "container-access-type" {
  type        = string
  description = "(Optional) The Access Level configured for this Container. Possible values are blob, container or private. Defaults to private"
}
