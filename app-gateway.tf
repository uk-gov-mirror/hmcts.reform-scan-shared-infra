data "azurerm_key_vault" "infra_vault" {
  name                = "infra-vault-${var.subscription}"
  resource_group_name = "${var.env == "prod" ? "core-infra-prod" : "cnp-core-infra"}"
}

data "azurerm_key_vault_secret" "cert" {
  key_vault_id = "${data.azurerm_key_vault.infra_vault.id}"
  name         = "${var.external_cert_name}"
}

data "azurerm_key_vault_secret" "cert_password" {
  name      = "${var.external_cert_name}-password"
  key_vault_id = "${data.azurerm_key_vault.infra_vault.id}"
}

module "appGw" {
  source            = "git@github.com:hmcts/cnp-module-waf?ref=master"
  env               = "${var.env}"
  subscription      = "${var.subscription}"
  location          = "${var.location}"
  wafName           = "${var.product}"
  resourcegroupname = "${azurerm_resource_group.rg.name}"
  common_tags       = "${var.common_tags}"

  # vNet connections
  gatewayIpConfigurations = [
    {
      name     = "internalNetwork"
      subnetId = "${data.azurerm_subnet.subnet_a.id}"
    },
  ]

  sslCertificates = [
    {
      name     = "${var.external_cert_name}"
      data     = "${data.azurerm_key_vault_secret.cert.value}"
      password = "${var.env == "prod" ? "" : "${data.azurerm_key_vault_secret.cert_password.value}"}"
    },
  ]

  # Http Listeners
  httpListeners = [
    {
      name                    = "https-listener"
      FrontendIPConfiguration = "appGatewayFrontendIP"
      FrontendPort            = "frontendPort443"
      Protocol                = "Https"
      SslCertificate          = "${var.external_cert_name}"
      hostName                = "${local.external_hostname}"
    },
  ]

  # Backend address Pools
  backendAddressPools = [
    {
      name = "${var.product}-${var.env}"

      backendAddresses = "${module.palo_alto.untrusted_ips_ip_address}"
    },
  ]

  backendHttpSettingsCollection = [
    {
      name                           = "backend"
      port                           = 80
      Protocol                       = "Http"
      AuthenticationCertificates     = ""
      CookieBasedAffinity            = "Disabled"
      probeEnabled                   = "True"
      probe                          = "http-probe"
      PickHostNameFromBackendAddress = "False"
      HostName                       = "${local.external_hostname}"
    },
  ]

  # Request routing rules
  requestRoutingRules = [
    {
      name                = "https"
      RuleType            = "Basic"
      httpListener        = "https-listener"
      backendAddressPool  = "${var.product}-${var.env}"
      backendHttpSettings = "backend"
    },
  ]

  probes = [
    {
      name                                = "http-probe"
      protocol                            = "Http"
      path                                = "/"
      interval                            = 30
      timeout                             = 30
      unhealthyThreshold                  = 5
      pickHostNameFromBackendHttpSettings = "false"
      backendHttpSettings                 = "backend"
      host                                = "${local.external_hostname}"
      healthyStatusCodes                  = "200-404" // MS returns 400 on /, allowing more codes in case they change it
    },
  ]
}
