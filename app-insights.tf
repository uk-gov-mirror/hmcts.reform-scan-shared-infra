resource "azurerm_application_insights" "appinsights" {
  name                = "${var.product}-${var.env}"
  location            = "${var.location}"
  resource_group_name = "${azurerm_resource_group.rg.name}"
  application_type    = "${var.application_type}"
  tags                = "${var.common_tags}"
}

# store app insights key in key vault
resource "azurerm_key_vault_secret" "appinsights_secret" {
  name         = "app-insights-instrumentation-key"
  value        = "${azurerm_application_insights.appinsights.instrumentation_key}"
  key_vault_id = "${data.azurerm_key_vault.key_vault.id}"
}
