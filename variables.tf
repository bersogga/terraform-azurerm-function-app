variable "function_app_name" {
  description = "Specifies the name of the Function App."
}

variable "resource_group_name" {
  description = "The name of the resource group in which to create the resources."
}

variable "location" {
  description = "Specifies the supported Azure location where the resources will be created."
}

variable "app_service_plan_id" {
  default     = ""
  description = "The ID of the App Service Plan within which to create this Function App."
}

variable "storage_connection_string" {
  default     = ""
  description = "The connection string of the backend storage account which will be used by this Function App (such as the dashboard, logs)."
}

variable "app_settings" {
  default     = {}
  description = "A key-value pair of App Settings."
}

variable "connection_string" {
  default     = []
  description = "A list connection strings."
}

variable "client_affinity_enabled" {
  default     = false
  description = "Should the Function App send session affinity cookies, which route client requests in the same session to the same instance?"
}

variable "enabled" {
  default     = true
  description = "Is the Function App enabled?"
}

variable "https_only" {
  default     = true
  description = "Can the Function App only be accessed via HTTPS?"
}

variable "version" {
  default     = "~1"
  description = "The runtime version associated with the Function App. Possible values are ~1 and beta."
}

variable "always_on" {
  default     = false
  description = "Should the Function App be loaded at all times?"
}

variable "use_32_bit_worker_process" {
  default     = true
  description = "Should the Function App run in 32 bit mode, rather than 64 bit mode? Should be true on Free or Shared plan."
}

variable "websockets_enabled" {
  default     = false
  description = "Should WebSockets be enabled?"
}

variable "msi_enabled" {
  default     = false
  description = "Should Managed Service Identity be enabled?"
}

variable "tags" {
  default     = {}
  description = "A mapping of tags to assign to the resource."
}
