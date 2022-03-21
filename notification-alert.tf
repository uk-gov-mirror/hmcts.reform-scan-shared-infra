module "reform-scan-notifications-alert" {
  source            = "git@github.com:hmcts/cnp-module-metric-alert"
  location          = azurerm_application_insights.appinsights.location
  app_insights_name = azurerm_application_insights.appinsights.name

  enabled    = var.env == "prod"
  alert_name = "Reform_Scan_notification"
  alert_desc = "Triggers when notification service receives at least 5 notifications within a 30 minutes window timeframe."

  app_insights_query = "traces | where message startswith 'Started processing notification message'"

  frequency_in_minutes       = 15
  time_window_in_minutes     = 30
  severity_level             = "1"
  action_group_name          = module.alert-action-group.action_group_name
  custom_email_subject       = "Reform Scan notifications"
  trigger_threshold_operator = "GreaterThan"
  trigger_threshold          = 4
  resourcegroup_name         = azurerm_resource_group.rg.name
}
