provider "azurerm" {
  features {}
}

locals {
  api_mgmt_name     = join("-", ["cft-api-mgmt", var.env])
  api_mgmt_rg       = join("-", ["cft", var.env,"network-rg"])
  fis_key_vault = join("-", ["fis", var.env])

  prl_api_url = join("", ["http://prl-cos-", var.env, ".service.core-compute-", var.env, ".internal"])
  s2sUrl           = join("", ["http://rpe-service-auth-provider-", var.env, ".service.core-compute-", var.env, ".internal"])

  # list of the thumbprints of the SSL certificates that should be accepted by the API (gateway)
  thumbprints_in_quotes     = formatlist("\"%s\"", var.api_gateway_test_certificate_thumbprints)
  thumbprints_in_quotes_str = join(",", local.thumbprints_in_quotes)
}

data "azurerm_key_vault" "fis_key_vault" {
  name                = local.fis_key_vault
  resource_group_name = local.fis_key_vault
}


data "azurerm_key_vault_secret" "s2s_client_id" {
  name         = "gateway-s2s-client-id"
  key_vault_id = data.azurerm_key_vault.fis_key_vault.id
}

data "azurerm_key_vault_secret" "s2s_client_secret" {
  name         = "gateway-s2s-client-secret"
  key_vault_id = data.azurerm_key_vault.fis_key_vault.id
}

resource "azurerm_api_management_user" "courtnav_user" {
  api_management_name = local.api_mgmt_name
  resource_group_name = local.api_mgmt_rg
  user_id             = "5931a75ae4bbd512288c690e"
  first_name          = "Shashi"
  last_name           = "Kariyappa"
  email               = "shashi.kariyappa@hmcts.net"
  state               = "active"

  provider = azurerm.cftappsdemo
}
