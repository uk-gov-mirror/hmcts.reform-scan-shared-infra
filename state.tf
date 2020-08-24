data "azurerm_subnet" "subnet_a" {
  name                 = "reform-scan"
  virtual_network_name = "core-infra-vnet-${var.env}"
  resource_group_name  = "core-infra-${var.env}"
}
