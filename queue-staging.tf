module "notifications-staging-queue" {
  source                                  = "git@github.com:hmcts/terraform-module-servicebus-queue"
  name                                    = "notifications-staging"
  namespace_name                          = module.queue-namespace-premium.name
  resource_group_name                     = azurerm_resource_group.rg.name
  lock_duration                           = "PT5M"
  requires_duplicate_detection            = true
  duplicate_detection_history_time_window = "PT59M"
}

resource "azurerm_key_vault_secret" "notifications_staging_queue_send_conn_str" {
  key_vault_id = module.vault.key_vault_id
  name         = "notifications-staging-queue-send-connection-string"
  value        = module.notifications-staging-queue.primary_send_connection_string
}

resource "azurerm_key_vault_secret" "notifications_staging_queue_listen_conn_str" {
  key_vault_id = module.vault.key_vault_id
  name         = "notifications-staging-queue-listen-connection-string"
  value        = module.notifications-staging-queue.primary_listen_connection_string
}

resource "azurerm_key_vault_secret" "notification_staging_queue_send_access_key" {
  name         = "notification-staging-queue-send-shared-access-key"
  value        = module.notifications-staging-queue.primary_send_shared_access_key
  key_vault_id = module.vault.key_vault_id
}

resource "azurerm_key_vault_secret" "notification_staging_queue_listen_access_key" {
  name         = "notification-staging-queue-listen-shared-access-key"
  value        = module.notifications-staging-queue.primary_listen_shared_access_key
  key_vault_id = module.vault.key_vault_id
}
