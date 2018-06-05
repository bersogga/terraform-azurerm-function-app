output "storage_account_id" {
  value       = "${azurerm_storage_account.storage_account.id}"
  description = "The storage account Resource ID."
}

output "primary_blob_endpoint" {
  value       = "${azurerm_storage_account.storage_account.primary_blob_endpoint}"
  description = "The endpoint URL for blob storage in the primary location."
}

output "app_service_plan_id" {
  value       = "${azurerm_app_service_plan.consumption_plan.*.id}"
  description = "The ID of the App Service Plan."
}

output "function_app_id" {
  value       = "${azurerm_function_app.function_app.id}"
  description = "The ID of the Function App."
}

output "default_hostname" {
  value       = "${azurerm_function_app.function_app.default_hostname}"
  description = "The default hostname associated with the Function App."
}

output "outbound_ip_addresses" {
  value       = "${azurerm_function_app.function_app.outbound_ip_addresses}"
  description = "A comma separated list of outbound IP addresses."
}
