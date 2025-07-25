locals {
  api_mgmt_suffix      = var.apim_suffix == "" ? var.env : var.apim_suffix
  api_mgmt_name        = "cft-api-mgmt-${local.api_mgmt_suffix}"
  api_mgmt_logger_name = "${local.api_mgmt_name}-logger"
  api_mgmt_rg          = join("-", ["cft", var.env, "network-rg"])
  fis_key_vault        = join("-", ["fis-kv", var.env])
  fis_key_vault_rg     = join("-", ["fis", var.env])

  prl_api_url = join("", ["http://prl-cos-", var.env, ".service.core-compute-", var.env, ".internal"])
  s2sUrl      = join("", ["http://rpe-service-auth-provider-", var.env, ".service.core-compute-", var.env, ".internal"])

}

provider "azurerm" {
  alias           = "aks-cftapps"
  subscription_id = var.aks_subscription_id
  features {}
}

data "azurerm_key_vault" "fis_key_vault" {
  name                = local.fis_key_vault
  resource_group_name = local.fis_key_vault_rg
}


data "azurerm_key_vault_secret" "s2s_client_id" {
  name         = "gateway-s2s-client-id"
  key_vault_id = data.azurerm_key_vault.fis_key_vault.id
}

data "azurerm_key_vault_secret" "s2s_client_secret" {
  name         = "gateway-s2s-client-secret"
  key_vault_id = data.azurerm_key_vault.fis_key_vault.id
}

