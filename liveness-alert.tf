#module "blob-router-service-liveness-alert" {
#  source            = "git::https://github.com/hmcts/cnp-module-metric-alert.git"
#  location          = var.location
#  app_insights_name = module.application_insights.name
#
#  enabled     = var.env == "prod"
#  alert_name  = "Blob_Router_Service_liveness"
#  alert_desc  = "Triggers when blob router service looks like being down within a 30 minutes window timeframe."
#  common_tags = var.common_tags
#
#  app_insights_query = <<EOF
#requests
#| where url endswith "/health/liveness" and success != "True"
#| where cloud_RoleName == "Blob Router Service"
#EOF
#
#  frequency_in_minutes       = "15"
#  time_window_in_minutes     = "16"
#  severity_level             = "2"
#  action_group_name          = module.alert-action-group.action_group_name
#  custom_email_subject       = "Blob Router Service liveness"
#  trigger_threshold_operator = "GreaterThan"
#  trigger_threshold          = "10"
#  resourcegroup_name         = azurerm_resource_group.rg.name
#}
#
#module "reform-scan-notification-service-liveness-alert" {
#  source            = "git::https://github.com/hmcts/cnp-module-metric-alert.git"
#  location          = var.location
#  app_insights_name = module.application_insights.name
#
#  enabled     = var.env == "prod"
#  alert_name  = "Reform_Scan_Notification_Service_liveness"
#  alert_desc  = "Triggers when reform scan notification service looks like being down within a 30 minutes window timeframe."
#  common_tags = var.common_tags
#
#  app_insights_query = <<EOF
#requests
#| where url endswith "/health/liveness" and success != "True"
#| where cloud_RoleName == "Reform Scan Notification Service"
#EOF
#
#  frequency_in_minutes       = "15"
#  time_window_in_minutes     = "16"
#  severity_level             = "2"
#  action_group_name          = module.alert-action-group.action_group_name
#  custom_email_subject       = "Reform Scan Notification Service liveness"
#  trigger_threshold_operator = "GreaterThan"
#  trigger_threshold          = "10"
#  resourcegroup_name         = azurerm_resource_group.rg.name
#}
