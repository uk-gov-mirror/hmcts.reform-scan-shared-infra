provider "azurerm" {
  alias           = "mgmt"
  subscription_id = var.mgmt_subscription_id
  features {}
}

provider "azurerm" {
  alias           = "cft-mgmt"
  subscription_id = "ed302caf-ec27-4c64-a05e-85731c3ce90e"
  features {}
}

provider "azurerm" {
  features {}
  skip_provider_registration = true
  alias                      = "private_endpoint"
  subscription_id            = var.aks_subscription_id
}

provider "azurerm" {
  features {}
  alias           = "aks"
  subscription_id = var.aks_subscription_id
}
