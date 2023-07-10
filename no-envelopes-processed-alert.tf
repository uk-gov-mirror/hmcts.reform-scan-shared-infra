module "no-cft-envelopes-processed-alert" {
  source            = "git@github.com:hmcts/cnp-module-metric-alert"
  location          = azurerm_application_insights.appinsights.location
  app_insights_name = azurerm_application_insights.appinsights.name

  enabled     = var.env == "prod"
  alert_name  = "No_cft_envelopes_processed_-_Blob_Router"
  alert_desc  = "Triggers when Blob Router did not process single CFT envelope in last hour within SLA."
  common_tags = var.common_tags

  app_insights_query = <<EOF
traces
| where message startswith "No Envelopes created in CFT"
EOF

  frequency_in_minutes       = "60"
  time_window_in_minutes     = "60"
  severity_level             = "4"
  action_group_name          = module.alert-action-group.action_group_name
  custom_email_subject       = "Blob Router - No CFT envelopes processed"
  trigger_threshold_operator = "GreaterThan"
  trigger_threshold          = "0"
  resourcegroup_name         = azurerm_resource_group.rg.name
}

module "no-crime-envelopes-processed-alert" {
  source            = "git@github.com:hmcts/cnp-module-metric-alert"
  location          = azurerm_application_insights.appinsights.location
  app_insights_name = azurerm_application_insights.appinsights.name

  enabled     = var.env == "prod"
  alert_name  = "No_crime_envelopes_processed_-_Blob_Router"
  alert_desc  = "Triggers when Blob Router did not process single Crime envelope in last hour within SLA."
  common_tags = var.common_tags

  app_insights_query = <<EOF
traces
| where message startswith "No Envelopes created in Crime"
EOF

  frequency_in_minutes       = "60"
  time_window_in_minutes     = "60"
  severity_level             = "4"
  action_group_name          = module.alert-action-group.action_group_name
  custom_email_subject       = "Blob Router - No Crime envelopes processed"
  trigger_threshold_operator = "GreaterThan"
  trigger_threshold          = "0"
  resourcegroup_name         = azurerm_resource_group.rg.name
}

module "no-pcq-envelopes-processed-alert" {
  source            = "git@github.com:hmcts/cnp-module-metric-alert"
  location          = azurerm_application_insights.appinsights.location
  app_insights_name = azurerm_application_insights.appinsights.name

  enabled     = var.env == "prod"
  alert_name  = "No_pcq_envelopes_processed_-_Blob_Router"
  alert_desc  = "Triggers when Blob Router did not process single PCQ envelope in last hour within SLA."
  common_tags = var.common_tags

  app_insights_query = <<EOF
traces
| where message startswith "No Envelopes created in PCQ"
EOF

  frequency_in_minutes       = "60"
  time_window_in_minutes     = "60"
  severity_level             = "4"
  action_group_name          = module.alert-action-group.action_group_name
  custom_email_subject       = "Blob Router - No PCQ envelopes processed"
  trigger_threshold_operator = "GreaterThan"
  trigger_threshold          = "0"
  resourcegroup_name         = azurerm_resource_group.rg.name
}
