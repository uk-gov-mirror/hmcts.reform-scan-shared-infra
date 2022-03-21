locals {
  product = "reform-scan"
  tags = "${merge(
    var.common_tags,
    map(
      "Team Contact", "#rbs",
      "Team Name", "Bulk Scan"
  ))}"
}

resource "azurerm_resource_group" "rg" {
  name     = "${var.product}-${var.env}"
  location = var.location

  tags = local.tags
}
