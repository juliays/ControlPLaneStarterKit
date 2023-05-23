variable "resource_group_name" {
  type        = string
  description = "Resource group name"
}
variable "control_plane_resource_group_name" {
  type        = string
  description = "Resource group name"
}

variable "grafana_account_location" {
  type        = string
  description = "Grafana resource group location"
}

variable "grafana_json_location" {
  type        = string
  description = "Grafana json location"
}

variable "grafana_name" {
  type        = string
  description = "Grafana name"
}

variable "laws-name" {
  type        = string
}