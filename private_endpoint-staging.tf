resource "azurerm_template_deployment" "private_endpoint_staging" {
  name                = "${local.account_name}stg-endpoint"
  resource_group_name = "${azurerm_resource_group.rg.name}"

  template_body = file("private_endpoint_template.json")

  parameters = {
    endpoint_name       = "${local.account_name}stg-endpoint"
    endpoint_location   = "${azurerm_resource_group.rg.location}"
    subnet_id           = "${data.azurerm_subnet.scan_storage_subnet.id}"
    storageaccount_id   = "${azurerm_storage_account.storage_account_staging.id}" 
    storageaccount_fqdn = "${azurerm_storage_account.storage_account_staging.primary_blob_endpoint}"
  }

  deployment_mode = "Incremental"
}
