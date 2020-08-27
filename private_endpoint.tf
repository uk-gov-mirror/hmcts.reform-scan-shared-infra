locals {
  scan_storage_vnet_name           = "core-infra-vnet-${var.env}"
  scan_storage_vnet_resource_group = "core-infra-${var.env}"
  scan_storage_vnet_subnet_name    = "scan-storage"
}

data "azurerm_subnet" "scan_storage_subnet" {
  name                 = "${local.scan_storage_vnet_subnet_name}"
  virtual_network_name = "${local.scan_storage_vnet_name}"
  resource_group_name  = "${local.scan_storage_vnet_resource_group}"
}

resource "azurerm_private_endpoint" "private_endpoint" {
  name                = "${local.account_name}"
  resource_group_name = "${azurerm_resource_group.rg.name}"
  location            = "${azurerm_resource_group.rg.location}"
  subnet_id           = "$azurerm_subnet.scan_storage_subnet.id}"

  private_service_connection {
    name                           = "${local.account_name}-private-connection"
    private_connection_resource_id = azurerm_storage_account.storage_account.id
    is_manual_connection           = false
    subresource_names              = ["blob"]
  }
}
