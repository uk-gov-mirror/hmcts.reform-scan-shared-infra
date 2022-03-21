variable "product" {}

variable "location" {
  default = "UK South"
}

variable "application_type" {
  type        = string
  default     = "web"
  description = "Type of Application Insights (Web/Other)"
}

variable "env" {}

variable "subscription" {}

variable "mgmt_subscription_id" {}

variable "common_tags" {
  type = map
}

variable "tenant_id" {}

variable "jenkins_AAD_objectId" {
  type        = string
  description = "(Required) The Azure AD object ID of a user, service principal or security group in the Azure Active Directory tenant for the vault. The object ID must be unique for the list of access policies."
}

variable "managed_identity_object_id" {
  default = ""
}

variable "managed_identity_api_mgmt" {
  default = ""
}

variable "external_hostname" {
  type        = string
  default     = "platform.hmcts.net"
  description = "Ending of hostname. Subdomains will be resolved in declaration of locals"
}

variable "enable_staging_account" {
  default = 0
}
