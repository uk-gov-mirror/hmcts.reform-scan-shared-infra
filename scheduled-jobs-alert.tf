module "blob-dispatcher-alert" {
  source            = "git::https://github.com/hmcts/cnp-module-metric-alert.git"
  location          = var.location
  app_insights_name = module.application_insights.name

  enabled     = var.env == "prod"
  alert_name  = "Dispatch_Files"
  alert_desc  = "Triggers when no logs from blob-dispatcher job found within timeframe."
  common_tags = var.common_tags

  app_insights_query = "traces | where message startswith 'Started blob-dispatcher job'"

  frequency_in_minutes       = "30"
  time_window_in_minutes     = "30"
  severity_level             = "1"
  action_group_name          = module.alert-action-group.action_group_name
  custom_email_subject       = "Reform Scan blob-dispatcher scheduled job alert"
  trigger_threshold_operator = "Equal"
  trigger_threshold          = "0"
  resourcegroup_name         = azurerm_resource_group.rg.name
}

module "delete-dispatched-files-alert" {
  source            = "git@github.com:hmcts/cnp-module-metric-alert"
  location          = var.location
  app_insights_name = module.application_insights.name

  enabled     = var.env == "prod"
  alert_name  = "Delete_Dispatched_Files"
  alert_desc  = "Triggers when no logs from delete-dispatched-files job found within timeframe."
  common_tags = var.common_tags

  app_insights_query = "traces | where message startswith 'Started delete-dispatched-files job'"

  frequency_in_minutes       = "120"
  time_window_in_minutes     = "120"
  severity_level             = "1"
  action_group_name          = module.alert-action-group.action_group_name
  custom_email_subject       = "Reform Scan delete-dispatched-files scheduled job alert"
  trigger_threshold_operator = "Equal"
  trigger_threshold          = "0"
  resourcegroup_name         = azurerm_resource_group.rg.name
}

module "handle-rejected-files-alert" {
  source            = "git@github.com:hmcts/cnp-module-metric-alert"
  location          = var.location
  app_insights_name = module.application_insights.name

  enabled     = var.env == "prod"
  alert_name  = "Handle_Rejected_Files"
  alert_desc  = "Triggers when no logs from handle-rejected-files job found within timeframe."
  common_tags = var.common_tags

  app_insights_query = "traces | where message startswith 'Started handle-rejected-files job'"

  # running every hour and checking for 25 hours time window ensures early alert
  frequency_in_minutes = "60"
  # 60 * 25 hours = 1500 min
  time_window_in_minutes = "1500"

  severity_level             = "1"
  action_group_name          = module.alert-action-group.action_group_name
  custom_email_subject       = "Reform Scan handle-rejected-files scheduled job alert"
  trigger_threshold_operator = "Equal"
  trigger_threshold          = "0"
  resourcegroup_name         = azurerm_resource_group.rg.name
}

module "reject-duplicates-alert" {
  source            = "git@github.com:hmcts/cnp-module-metric-alert"
  location          = var.location
  app_insights_name = module.application_insights.name

  enabled     = var.env == "prod"
  alert_name  = "Reject_Duplicates"
  alert_desc  = "Triggers when no logs from reject-duplicates job found within timeframe."
  common_tags = var.common_tags

  app_insights_query = "traces | where message startswith 'Started reject-duplicates job'"

  # running every hour and checking for 25 hours time window ensures early alert
  frequency_in_minutes = "60"
  # 60 * 25 hours = 1500 min
  time_window_in_minutes = "1500"

  severity_level             = "1"
  action_group_name          = module.alert-action-group.action_group_name
  custom_email_subject       = "Reform Scan reject-duplicates scheduled job alert"
  trigger_threshold_operator = "Equal"
  trigger_threshold          = "0"
  resourcegroup_name         = azurerm_resource_group.rg.name
}

module "delete-rejected-files-alert" {
  source            = "git@github.com:hmcts/cnp-module-metric-alert"
  location          = var.location
  app_insights_name = module.application_insights.name

  enabled     = var.env == "prod"
  alert_name  = "Delete_Rejected_Files"
  alert_desc  = "Triggers when no logs from delete-rejected-files job found within timeframe."
  common_tags = var.common_tags

  app_insights_query = "traces | where message startswith 'Started delete-rejected-files job'"

  # running every hour and checking for 25 hours time window ensures early alert
  frequency_in_minutes = "60"
  # 60 * 25 hours = 1500 min
  time_window_in_minutes = "1500"

  severity_level             = "1"
  action_group_name          = module.alert-action-group.action_group_name
  custom_email_subject       = "Reform Scan delete-rejected-files scheduled job alert"
  trigger_threshold_operator = "Equal"
  trigger_threshold          = "0"
  resourcegroup_name         = azurerm_resource_group.rg.name
}

module "check-new-envelopes-alert" {
  source            = "git@github.com:hmcts/cnp-module-metric-alert"
  location          = var.location
  app_insights_name = module.application_insights.name

  enabled     = var.env == "prod"
  alert_name  = "Check-New-Envelopes"
  alert_desc  = "Triggers when no logs from check-new-envelopes job found within timeframe."
  common_tags = var.common_tags

  app_insights_query = "traces | where message startswith 'Started check-new-envelopes job'"

  frequency_in_minutes   = "60"
  time_window_in_minutes = "60"

  severity_level             = "1"
  action_group_name          = module.alert-action-group.action_group_name
  custom_email_subject       = "Reform Scan check-new-envelopes scheduled job alert"
  trigger_threshold_operator = "Equal"
  trigger_threshold          = "0"
  resourcegroup_name         = azurerm_resource_group.rg.name
}

module "send-notifications-alert" {
  source            = "git@github.com:hmcts/cnp-module-metric-alert"
  location          = var.location
  app_insights_name = module.application_insights.name

  enabled     = var.env == "prod"
  alert_name  = "Reform-Scan-Send-Notifications"
  alert_desc  = "Triggers when no logs from send-notifications job found within timeframe."
  common_tags = var.common_tags

  app_insights_query = "traces | where message startswith 'Started send-notifications job'"

  frequency_in_minutes       = "20"
  time_window_in_minutes     = "30"
  severity_level             = "1"
  action_group_name          = module.alert-action-group.action_group_name
  custom_email_subject       = "Reform Scan send-notifications scheduled job alert"
  trigger_threshold_operator = "Equal"
  trigger_threshold          = "0"
  resourcegroup_name         = azurerm_resource_group.rg.name
}

module "send-notifications-to-scan-provider-alert" {
  source            = "git@github.com:hmcts/cnp-module-metric-alert"
  location          = var.location
  app_insights_name = module.application_insights.name

  enabled     = var.env == "prod"
  alert_name  = "Reform-Scan-Pending-Notifications"
  alert_desc  = "Triggers when no logs from pending-notifications job found within timeframe."
  common_tags = var.common_tags

  app_insights_query = "traces | where message startswith 'Started pending-notifications task'"

  # task delay is 30min for prod. adding extra 5 min for telemetry lag
  frequency_in_minutes       = "30"
  time_window_in_minutes     = "35"
  severity_level             = "1"
  action_group_name          = module.alert-action-group.action_group_name
  custom_email_subject       = "Reform Scan pending-notifications scheduled job alert"
  trigger_threshold_operator = "Equal"
  trigger_threshold          = "0"
  resourcegroup_name         = azurerm_resource_group.rg.name
}
