variable "resource_group_name" {
  type        = string
  description = "Resource group name"
}

variable "log_analytics_workspace_location" {
  type        = string
  description = "log_analytics_workspace location"
}

variable "log_analytics_workspace_name" {
  type        = string
  description = "log_analytics_workspace name"
}

variable "log_analytics_workspace_sku" {
  type        = string
  description = "log_analytics_workspace sku"
}


variable "log_analytics_workspace_retention" {
  type        = string
  description = "log_analytics_workspace retention in days"
}

