resource "azurerm_private_endpoint" "private_endpoint_stg" {
  name                = "${local.account_name}stg-endpoint"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  subnet_id           = data.azurerm_subnet.scan_storage_subnet.id

  private_service_connection {
    name                           = "${local.account_name}stg-endpoint"
    private_connection_resource_id = azurerm_storage_account.storage_account_staging[0].id
    is_manual_connection           = false
    subresource_names              = ["blob"]
  }
  
  count = var.enable_staging_account
}
