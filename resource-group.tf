locals {
  bsp_product = "bulk-scan"
  tags        = "${merge(var.common_tags, map("Team Contact", "#rbs"))}"
}

resource "azurerm_resource_group" "rg" {
  name     = "${var.product}-${var.env}"
  location = "${var.location}"

  tags = "${local.tags}"
}

resource "azurerm_resource_group" "bulkscan_rg" {
  name     = "${local.bsp_product}-${var.env}"
  location = "${var.location}"

  tags = "${local.tags}"
}
