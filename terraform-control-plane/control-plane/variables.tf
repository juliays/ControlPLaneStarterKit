variable "azure-region" {
  type        = string
  description = "The Azure region that items should be provisioned in."
}

variable "control-plane-resource-group-name" {
  type        = string
  description = "The name of the resource group that items should be provisioned in."
}

variable "sql_container_name" {
  type        = string
  description = "SQL API container name."
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

variable "grafana_json_location" {
  type        = string
  description = "The grafana json location."
}

variable "grafana_name" {
  type        = string
  description = "The grafana name."
}

variable "ARM_CLIENT_ID" {
  type        = string
  description = "variable to access ARM_CLIENT_ID env variable for grafana"
}
