locals {
  stripped_product_stg  = replace(var.product, "-", "")
  account_name_stg      = "${local.stripped_product_stg}${var.env}staging"
  prod_hostname_stg     = "${local.stripped_product_stg}stg.${var.external_hostname}"
  nonprod_hostname_stg  = "${local.stripped_product_stg}stg.${var.env}.${var.external_hostname}"
  external_hostname_stg = var.env == "prod" ? local.prod_hostname_stg : local.nonprod_hostname_stg

  // for each client service two containers are created: one named after the service
  // and another one, named {service_name}-rejected, for storing envelopes rejected by process
  client_containers_stg = var.enable_staging_account == 1 ? ["bulkscanauto", "bulkscan", "cmc", "crime", "divorce", "nfd", "finrem", "pcq", "probate", "sscs", "publiclaw", "privatelaw", "adoption", "sscs-ibca"] : []
}

resource "azurerm_storage_account" "storage_account_staging" {
  name                = local.account_name_stg
  resource_group_name = azurerm_resource_group.rg.name

  location                 = azurerm_resource_group.rg.location
  account_tier             = "Standard"
  account_replication_type = var.staging_storage_account_repl_type

  allow_nested_items_to_be_public = false

  network_rules {
    virtual_network_subnet_ids = [
    data.azurerm_subnet.scan_storage_subnet.id, data.azurerm_subnet.jenkins_subnet.id, data.azurerm_subnet.aks_00_subnet.id, data.azurerm_subnet.aks_01_subnet.id]
    bypass         = ["Logging", "Metrics", "AzureServices"]
    default_action = "Deny"
  }

  tags = local.tags

  count = var.enable_staging_account
}

resource "azurerm_storage_container" "client_containers_stg" {
  name                 = local.client_containers_stg[count.index]
  storage_account_name = azurerm_storage_account.storage_account_staging[0].name
  count                = length(local.client_containers_stg)
}

resource "azurerm_storage_container" "client_rejected_containers_stg" {
  name                 = "${local.client_containers_stg[count.index]}-rejected"
  storage_account_name = azurerm_storage_account.storage_account_staging[0].name
  count                = length(local.client_containers_stg)
}

# store blob storage secrets in key vault
resource "azurerm_key_vault_secret" "storage_account_staging_name" {
  key_vault_id = module.vault.key_vault_id
  name         = "storage-account-staging-name"
  value        = azurerm_storage_account.storage_account_staging[0].name

  count = var.enable_staging_account
}

resource "azurerm_key_vault_secret" "storage_account_staging_primary_key" {
  key_vault_id = module.vault.key_vault_id
  name         = "storage-account-staging-primary-key"
  value        = azurerm_storage_account.storage_account_staging[0].primary_access_key

  count = var.enable_staging_account
}

resource "azurerm_key_vault_secret" "storage_account_staging_secondary_key" {
  key_vault_id = module.vault.key_vault_id
  name         = "storage-account-staging-secondary-key"
  value        = azurerm_storage_account.storage_account_staging[0].secondary_access_key

  count = var.enable_staging_account
}
