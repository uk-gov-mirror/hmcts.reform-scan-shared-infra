data "azurerm_subnet" "jenkins_subnet" {
  provider             = azurerm.mgmt
  name                 = "iaas"
  virtual_network_name = local.mgmt_network_name
  resource_group_name  = local.mgmt_network_rg_name
}

data "azurerm_subnet" "aks_00_subnet" {
  provider             = azurerm.mgmt
  name                 = "aks-00"
  virtual_network_name = local.mgmt_network_name
  resource_group_name  = local.mgmt_network_rg_name
}

data "azurerm_subnet" "aks_01_subnet" {
  provider             = azurerm.mgmt
  name                 = "aks-01"
  virtual_network_name = local.mgmt_network_name
  resource_group_name  = local.mgmt_network_rg_name
}

data "azurerm_subnet" "app_aks_00_subnet" {
  provider             = azurerm.aks
  name                 = "aks-00"
  virtual_network_name = local.app_aks_network_name
  resource_group_name  = local.app_aks_network_rg_name
}

data "azurerm_subnet" "app_aks_01_subnet" {
  provider             = azurerm.aks
  name                 = "aks-01"
  virtual_network_name = local.app_aks_network_name
  resource_group_name  = local.app_aks_network_rg_name
}

## Delete when DTSPO-5565 is complete
data "azurerm_subnet" "arm_aks_00_subnet" {
  count                = var.env == "prod" ? 1 : 0
  provider             = azurerm.aks
  name                 = "aks-00"
  virtual_network_name = "core-${local.aks_env}-vnet"
  resource_group_name  = "aks-infra-${local.aks_env}-rg"
}

## Delete when DTSPO-5565 is complete
data "azurerm_subnet" "arm_aks_01_subnet" {
  count                = var.env == "prod" ? 1 : 0
  provider             = azurerm.aks
  name                 = "aks-01"
  virtual_network_name = "core-${local.aks_env}-vnet"
  resource_group_name  = "aks-infra-${local.aks_env}-rg"
}