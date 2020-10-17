resource "azurerm_frontdoor" "frontdoor" {
  name                                         = "${var.product}-${var.env}-frontdoor"
  location                                     = "Global"
  resource_group_name                          = "${azurerm_resource_group.rg.name}"
  enforce_backend_pools_certificate_name_check = false

  routing_rule {
    name               = "storageRoutingRule"
    accepted_protocols = ["Https"]
    patterns_to_match  = ["/*"]
    frontend_endpoints = ["storageFrontendEndpoint"]
    forwarding_configuration {
      forwarding_protocol = "MatchRequest"
      backend_pool_name   = "storageBackend"
    }
  }
  
  routing_rule {
    name               = "stgStorageRoutingRule"
    accepted_protocols = ["Https"]
    patterns_to_match  = ["/*"]
    frontend_endpoints = ["stgStorageFrontendEndpoint"]
    forwarding_configuration {
      forwarding_protocol = "MatchRequest"
      backend_pool_name   = "stgStorageBackend"
    }
  }  

  backend_pool_load_balancing {
    name = "storageLoadBalancingSettings"
  }

  backend_pool_health_probe {
    name = "storageHealthProbeSetting"
    protocol = "Https"
  }

  backend_pool {
    name = "storageBackend"
    backend {
      host_header = "${azurerm_storage_account.storage_account.primary_blob_host}"
      address     = "${var.frontdoor_backend}"
      http_port   = 80
      https_port  = 443
    }

    load_balancing_name = "storageLoadBalancingSettings"
    health_probe_name   = "storageHealthProbeSetting"
  }
  
  backend_pool {
    name = "stgStorageBackend"
    backend {
      host_header = "${azurerm_storage_account.storage_account_staging.primary_blob_host}"
      address     = "${var.stg_frontdoor_backend}"
      http_port   = 80
      https_port  = 443
    }

    load_balancing_name = "storageLoadBalancingSettings"
    health_probe_name   = "storageHealthProbeSetting"
  }

  frontend_endpoint {
    name                              = "storageFrontendEndpoint"
    host_name                         = "v2-${var.frontdoor_hostname}"
    custom_https_provisioning_enabled = true
    custom_https_configuration {
      certificate_source                         = "AzureKeyVault"
      azure_key_vault_certificate_vault_id       = data.azurerm_key_vault.infra_vault.id
      azure_key_vault_certificate_secret_name    = var.external_cert_name
      azure_key_vault_certificate_secret_version = data.azurerm_key_vault_secret.cert.version  
    }
  }

  frontend_endpoint {
    name                              = "stgStorageFrontendEndpoint"
    host_name                         = "v2-stg${var.frontdoor_hostname}"
    custom_https_provisioning_enabled = true
    custom_https_configuration {
      certificate_source                         = "AzureKeyVault"
      azure_key_vault_certificate_vault_id       = data.azurerm_key_vault.infra_vault.id
      azure_key_vault_certificate_secret_name    = var.external_cert_name
      azure_key_vault_certificate_secret_version = data.azurerm_key_vault_secret.cert.version  
    }
  }  
 
  frontend_endpoint {
    name                              = "defaultFrontendEndpoint"
    host_name                         = "${var.product}-${var.env}-FrontDoor.azurefd.net"
    custom_https_provisioning_enabled = false
  }
}

data "azurerm_key_vault" "infra_vault" {
  name = "infra-vault-${var.subscription}"
  resource_group_name = "${var.env == "prod" ? "core-infra-prod" : "cnp-core-infra"}"
}


data "azurerm_key_vault_secret" "cert" {
  name      = "${var.external_cert_name}"
  key_vault_id = "${data.azurerm_key_vault.infra_vault.id}"
}
