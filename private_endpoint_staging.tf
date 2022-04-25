data "azurerm_private_dns_zone" "private_link_dns_zone_stg" {
  provider            = azurerm.mgmt
  name                = "privatelink.blob.core.windows.net"
  resource_group_name = "core-infra-intsvc-rg"
}

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

  private_dns_zone_group {
    name                 = data.azurerm_private_dns_zone.private_link_dns_zone_stg.name
    private_dns_zone_ids = [data.azurerm_private_dns_zone.private_link_dns_zone.id]
  }

  count = var.enable_staging_account
}
