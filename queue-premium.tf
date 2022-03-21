module "queue-namespace-premium" {
  source              = "git@github.com:hmcts/terraform-module-servicebus-namespace?ref=master"
  name                = "${local.product}-servicebus-${var.env}-premium"
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name
  sku                 = "Premium"
  capacity            = 1
  zone_redundant      = true
  env                 = var.env
  common_tags         = local.tags
}

module "notifications-queue-premium" {
  source                                  = "git@github.com:hmcts/terraform-module-servicebus-queue?ref=master"
  name                                    = "notifications"
  namespace_name                          = module.queue-namespace-premium.name
  resource_group_name                     = azurerm_resource_group.rg.name
  lock_duration                           = "PT5M"
  requires_duplicate_detection            = true
  duplicate_detection_history_time_window = "PT59M"
}

resource "azurerm_key_vault_secret" "notifications_queue_send_conn_str_premium" {
  key_vault_id = module.vault.key_vault_id
  name         = "notifications-queue-send-connection-string-premium"
  value        = module.notifications-queue-premium.primary_send_connection_string
}

resource "azurerm_key_vault_secret" "notifications_queue_listen_conn_str_premium" {
  key_vault_id = module.vault.key_vault_id
  name         = "notifications-queue-listen-connection-string-premium"
  value        = module.notifications-queue-premium.primary_listen_connection_string
}

resource "azurerm_key_vault_secret" "notification_queue_send_access_key_premium" {
  name         = "notification-queue-send-shared-access-key-premium"
  value        = module.notifications-queue-premium.primary_send_shared_access_key
  key_vault_id = module.vault.key_vault_id
}

resource "azurerm_key_vault_secret" "notification_queue_listen_access_key_premium" {
  name         = "notification-queue-listen-shared-access-key-premium"
  value        = module.notifications-queue-premium.primary_listen_shared_access_key
  key_vault_id = module.vault.key_vault_id
}