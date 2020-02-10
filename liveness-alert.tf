module "blob-router-service-liveness-alert" {
  source            = "git@github.com:hmcts/cnp-module-metric-alert"
  location          = "${azurerm_application_insights.appinsights.location}"
  app_insights_name = "${azurerm_application_insights.appinsights.name}"

  enabled    = "${var.env == "prod"}"
  alert_name = "Blob_Router_Service_liveness"
  alert_desc = "Triggers when blob router service looks like being down within a 30 minutes window timeframe."

  app_insights_query = <<EOF
requests
| where name == "GET /health" and resultCode != "200"
| where cloud_RoleName == "Blob Router Service"
EOF

  frequency_in_minutes       = 15
  time_window_in_minutes     = 30
  severity_level             = "2"
  action_group_name          = "${module.alert-action-group.action_group_name}"
  custom_email_subject       = "Blob Router Service liveness"
  trigger_threshold_operator = "GreaterThan"
  trigger_threshold          = 5
  resourcegroup_name         = "${azurerm_resource_group.rg.name}"
}
