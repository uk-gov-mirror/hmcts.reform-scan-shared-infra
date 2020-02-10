locals {
  product = "reform-scan"
  tags        = "${merge(var.common_tags, map("Team Contact", "#rbs"))}"
}

resource "azurerm_resource_group" "rg" {
  name     = "${var.product}-${var.env}"
  location = "${var.location}"

  tags = "${local.tags}"
}

resource "azurerm_resource_group" "reform_scan_rg" {
  name     = "${local.product}-${var.env}"
  location = "${var.location}"

  tags = "${local.tags}"
}
