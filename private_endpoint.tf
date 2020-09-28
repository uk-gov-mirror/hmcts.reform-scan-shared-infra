locals {
  scan_storage_vnet_name           = "${var.env == "aat" ? "scan-storage-vnet-aat" : "core-infra-vnet-${var.env}"}"
  scan_storage_vnet_resource_group = "core-infra-${var.env}"
  scan_storage_vnet_subnet_name    = "scan-storage"
}

data "azurerm_subnet" "scan_storage_subnet" {
  name                 = "${local.scan_storage_vnet_subnet_name}"
  virtual_network_name = "${local.scan_storage_vnet_name}"
  resource_group_name  = "${local.scan_storage_vnet_resource_group}"
}

resource "azurerm_template_deployment" "private_endpoint" {
  name                = "${local.account_name}-endpoint"
  resource_group_name = "${azurerm_resource_group.rg.name}"

  template_body = file("private_endpoint_template.json")

  parameters = {
    endpoint_name       = "${local.account_name}-endpoint"
    endpoint_location   = "${azurerm_resource_group.rg.location}"
    subnet_id           = "${data.azurerm_subnet.scan_storage_subnet.id}"
    storageaccount_id   = "${azurerm_storage_account.storage_account.id}" 
    storageaccount_fqdn = "${azurerm_storage_account.storage_account.primary_blob_endpoint}"
  }

  deployment_mode = "Incremental"
}
