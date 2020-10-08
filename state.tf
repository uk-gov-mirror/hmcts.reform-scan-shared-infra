terraform {
  backend "azurerm" {}
}

data "azurerm_subnet" "subnet_a" {
  name                 = "reform-scan"
  virtual_network_name = "core-infra-vnet-${var.env}"
  resource_group_name  = "core-infra-${var.env}"
}

provider "azurerm" {
  alias           = "cft-mgmt"
  subscription_id = "ed302caf-ec27-4c64-a05e-85731c3ce90e"
  features {}
}
