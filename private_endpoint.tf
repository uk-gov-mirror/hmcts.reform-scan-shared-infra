locals {
  scan_storage_vnet_name           = "core-infra-vnet-${var.env}"
  scan_storage_vnet_resource_group = "core-infra-${var.env}"
  scan_storage_vnet_subnet_name    = "scan-storage"
}

data "azurerm_private_dns_zone" "private_link_dns_zone" {
  provider            = azurerm.mgmt
  name                = "privatelink.blob.core.windows.net"
  resource_group_name = "core-infra-intsvc-rg"
}

data "azurerm_subnet" "scan_storage_subnet" {
  name                 = local.scan_storage_vnet_subnet_name
  virtual_network_name = local.scan_storage_vnet_name
  resource_group_name  = local.scan_storage_vnet_resource_group
}

resource "azurerm_private_endpoint" "private_endpoint" {
  name                = "${local.account_name}-endpoint"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  subnet_id           = data.azurerm_subnet.scan_storage_subnet.id

  private_service_connection {
    name                           = "${local.account_name}-endpoint"
    private_connection_resource_id = azurerm_storage_account.storage_account.id
    is_manual_connection           = false
    subresource_names              = ["blob"]
  }

  private_dns_zone_group {
    name                 = data.azurerm_private_dns_zone.private_link_dns_zone.name
    private_dns_zone_ids = [data.azurerm_private_dns_zone.private_link_dns_zone.id]
  }
}