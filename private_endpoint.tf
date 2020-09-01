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

# resource "azurerm_private_endpoint" "private_endpoint" {
#   name                = "${local.account_name}"
#   resource_group_name = "${azurerm_resource_group.rg.name}"
#   location            = "${azurerm_resource_group.rg.location}"
#   subnet_id           = "$azurerm_subnet.scan_storage_subnet.id}"

#   private_service_connection {
#     name                           = "${local.account_name}-private-connection"
#     private_connection_resource_id = azurerm_storage_account.storage_account.id
#     is_manual_connection           = false
#     subresource_names              = ["blob"]
#   }
# }


resource "azurerm_template_deployment" "private_endpoint" {
  name                = "${local.account_name}"
  resource_group_name = "${azurerm_resource_group.rg.name}"

  template_body = file("private_endpoint_template.json")

  parameters = {
    endpoint_name       = "${local.account_name}"
    endpoint_location   = "uksouth"
    vnet_id             = "/subscriptions/7a4e3bd5-ae3a-4d0c-b441-2188fee3ff1c/resourceGroups/core-infra-perftest/providers/Microsoft.Network/virtualNetworks/core-infra-vnet-perftest"
    subnet_name         = "scan-storage"
    storageaccount_id   = "/subscriptions/7a4e3bd5-ae3a-4d0c-b441-2188fee3ff1c/resourceGroups/bulk-scan-perftest/providers/Microsoft.Storage/storageAccounts/bulkscanperftest"
    storageaccount_fqdn = "bulkscanperftest.blob.core.windows.net"
  }

  deployment_mode = "Incremental"
}
