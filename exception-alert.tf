// single alert to minify unnecessary cost because threshold used in here is minimal
module "reform-scan-exception-alert" {
  source            = "git@github.com:hmcts/cnp-module-metric-alert"
  location          = azurerm_application_insights.appinsights.location
  app_insights_name = azurerm_application_insights.appinsights.name

  enabled     = var.env == "prod"
  alert_name  = "Reform_Scan_exception"
  alert_desc  = "Triggers when blob router service receives at least one exception within a 15 minutes window timeframe."
  common_tags = var.common_tags

  app_insights_query = <<EOF
union exceptions, traces
| where severityLevel >= 3
EOF

  frequency_in_minutes       = "15"
  time_window_in_minutes     = "15"
  severity_level             = "1"
  action_group_name          = module.alert-action-group.action_group_name
  custom_email_subject       = "Reform Scan exception"
  trigger_threshold_operator = "GreaterThan"
  trigger_threshold          = "0"
  resourcegroup_name         = azurerm_resource_group.rg.name
}
