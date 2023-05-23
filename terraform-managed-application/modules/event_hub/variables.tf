variable "prefix" {
  type        = string
  description = "A prefix for naming each of the resources to be created."
}

variable "suffix" {
  type        = string
  description = "An extra string to help ensure uniqueness in naming."
}

variable "azure-region" {
  type        = string
  description = "The Azure region that items should be provisioned in."
}

variable "resource-group-name" {
  type        = string
  description = "The resource group where these resources will be provisioned."
}

variable "eventhub-namespace-sku" {
  type        = string
  default     = "Standard"
  description = "The namespace sku."
}

variable "eventhub-namespace-throuput-units" {
  type        = number
  default     = 1
  description = "Specifies the Capacity / Throughput Units for a Standard SKU namespace. Default capacity has a maximum of 2, but can be increased in blocks of 2 on a committed purchase basis. Defaults to 1."
}

variable "eventhub-partition-count" {
  type        = number
  default     = 1
  description = "The partition count for the event hub."
}

variable "tag" {
  type        = string
  default     = ""
  description = "An optional tag to be put on the resource."
}

variable "namespace-authz-rule-listen" {
  type        = bool
  default     = true
  description = "Grants listen access to this Authorization Rule."
}

variable "namespace-authz-rule-send" {
  type        = bool
  default     = true
  description = "Grants send access to this Authorization Rule"
}

variable "namespace-authz-rule-manage" {
  type        = bool
  default     = false
  description = "Grants manage access to this Authorization Rule. When this property is true - both listen and send must be too."
}

variable "message-retention" {
  type        = number
  default     = 1
  description = "Specifies the number of days to retain the events for this Event Hub."
}

variable "eventhub-authz-rule-listen" {
  type        = bool
  default     = true
  description = "Does this Authorization Rule have permissions to Listen to the Event Hub? "
}

variable "eventhub-authz-rule-send" {
  type        = bool
  default     = true
  description = "Does this Authorization Rule have permissions to Send to the Event Hub?"
}

variable "eventhub-authz-rule-manage" {
  type        = bool
  default     = false
  description = "Does this Authorization Rule have permissions to Manage to the Event Hub? When this property is true - both listen and send must be too."
}
