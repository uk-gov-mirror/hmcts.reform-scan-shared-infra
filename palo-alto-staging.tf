locals {
  trusted_vnet_name_stg           = "core-infra-vnet-${var.env}"
  trusted_vnet_resource_group_stg = "core-infra-${var.env}"
  trusted_vnet_subnet_name_stg    = "palo-trusted"
}

module "palo_alto_staging" {
  source       = "git@github.com:hmcts/cnp-module-palo-alto?ref=test-pip-upgrade"
  subscription = "${var.subscription}"
  env          = "${var.env}"
  product      = "${var.product}-stg"
  common_tags  = "${var.common_tags}"

  untrusted_vnet_name           = "core-infra-vnet-${var.env}"
  untrusted_vnet_resource_group = "core-infra-${var.env}"
  untrusted_vnet_subnet_name    = "palo-untrusted"
  trusted_vnet_name             = "${local.trusted_vnet_name_stg}"
  trusted_vnet_resource_group   = "${local.trusted_vnet_resource_group_stg}"
  trusted_vnet_subnet_name      = "${local.trusted_vnet_subnet_name_stg}"
  trusted_destination_host      = "${azurerm_storage_account.storage_account_staging.name}.blob.core.windows.net"
  cluster_size                  = "${var.palo_cluster_size}"
}
