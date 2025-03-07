variable "product" {
  type    = string
  default = "family"
}

variable "product_name" {
  type    = string
  default = "case"
}

variable "document_product_name" {
  type    = string
  default = "document"
}

variable "case_search_name" {
  type    = string
  default = "case-search"
}

variable "document_product_get_name" {
  type    = string
  default = "fis-document-get"
}

variable "location" {
  type    = string
  default = "UK South"
}

variable "env" {
  type = string
}

variable "tenant_id" {
  type        = string
  description = "(Required) The Azure Active Directory tenant ID that should be used for authenticating requests to the key vault. This is usually sourced from environemnt variables and not normally required to be specified."
}

variable "jenkins_AAD_objectId" {
  type        = string
  description = "(Required) The Azure AD object ID of a user, service principal or security group in the Azure Active Directory tenant for the vault. The object ID must be unique for the list of access policies."
}

# thumbprint of the SSL certificate for API gateway tests
variable "api_gateway_test_certificate_thumbprints" {
  type    = list(any)
  default = [] # TODO: remove default and provide environment-specific values
}

variable "common_tags" {
  type = map(string)
}

variable "aks_subscription_id" {
}

variable "apim_suffix" {
  default = ""
}
