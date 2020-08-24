terraform {
  backend "azurerm" {
    resource_group_name  = "mgmt"
    storage_account_name = "capybaramgmt"
    container_name       = "terraform"
    key                  = "reform-scan-shared-infra.tfstate"
  }
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "2.24.0"
    }
  }
}