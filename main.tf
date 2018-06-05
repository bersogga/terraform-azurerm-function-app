resource "random_id" "storage_account" {
  # Generate a random id for the backend storage account.
  byte_length = 2
}

resource "azurerm_storage_account" "storage_account" {
  # Create the backend storage account which will be used by this Function App (such as the dashboard, logs).
  name                     = "${replace("${lower(var.function_app_name)}","/[^a-z0-9]/","")}${random_id.storage_account.hex}"
  location                 = "${var.location}"
  resource_group_name      = "${var.resource_group_name}"
  account_tier             = "Standard"
  account_replication_type = "LRS"
  tags                     = "${var.tags}"
}

resource "azurerm_app_service_plan" "consumption_plan" {
  # Create the Consumption Plan which will be used by this Function App
  count               = "${var.app_service_plan_id == "" ? 1 : 0}"
  name                = "${var.function_app_name}"
  location            = "${var.location}"
  resource_group_name = "${var.resource_group_name}"
  kind                = "FunctionApp"

  sku {
    tier = "Dynamic"
    size = "Y1"
  }

  tags = "${var.tags}"
}

resource "azurerm_function_app" "function_app" {
  # Create a Function App
  name                      = "${var.function_app_name}"
  location                  = "${var.location}"
  resource_group_name       = "${var.resource_group_name}"
  app_service_plan_id       = "${var.app_service_plan_id == "" ? azurerm_app_service_plan.consumption_plan.id : var.app_service_plan_id}"
  storage_connection_string = "${azurerm_storage_account.storage_account.primary_connection_string}"
  app_settings              = "${var.app_settings}"
  connection_string         = "${var.connection_string}"
  client_affinity_enabled   = "${var.client_affinity_enabled}"
  enabled                   = "${var.enabled}"
  https_only                = "${var.https_only}"
  version                   = "${var.version}"

  site_config {
    always_on                 = "${var.always_on}"
    use_32_bit_worker_process = "${var.use_32_bit_worker_process}"
    websockets_enabled        = "${var.websockets_enabled}"
  }

  tags = "${var.tags}"
}

resource "azurerm_template_deployment" "msi_enabled" {
  # Create a template deployment to enable Managed Service Identity for the Funcion App, which is not yet natively supported by Terraform.
  count               = "${var.msi_enabled ? 1 : 0}"
  name                = "${var.function_app_name}-msi-enabled"
  resource_group_name = "${var.resource_group_name}"

  template_body = <<DEPLOY
{
  "$schema": "https://schema.management.azure.com/schemas/2015-01-01/deploymentTemplate.json#",
  "contentVersion": "1.0.0.0",
  "parameters": {
    "functionAppName": {
      "type": "string"
    }
  },
  "resources": [
    {
      "type": "Microsoft.Web/sites",
      "name": "[parameters('functionAppName')]",
      "apiVersion": "2016-08-01",
      "location": "[resourceGroup().location]",
      "identity": {
          "type": "SystemAssigned"
      },
      "properties": {}
    }
  ]
}
DEPLOY

  parameters {
    "functionAppName" = "${var.function_app_name}"
  }

  deployment_mode = "Incremental"

  depends_on = ["azurerm_function_app.function_app"]
}
