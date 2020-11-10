variable "product" {}

variable "location" {
  default = "UK South"
}

variable "application_type" {
  type        = "string"
  default     = "web"
  description = "Type of Application Insights (Web/Other)"
}

variable "env" {}

variable "subscription" {}

variable "mgmt_subscription_id" {}

variable "common_tags" {
  type = "map"
}

variable "tenant_id" {}

variable "jenkins_AAD_objectId" {
  type        = "string"
  description = "(Required) The Azure AD object ID of a user, service principal or security group in the Azure Active Directory tenant for the vault. The object ID must be unique for the list of access policies."
}

variable "managed_identity_object_id" {
  default = ""
}

variable "wafFileUploadLimit" {
  description = "Maximum file upload size in MB for WAF"
  default = "100"
}
