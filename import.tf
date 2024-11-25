# Obtain the subscription ID of the problematic resource
data "azurerm_subscription" "current" {}

import {
  for_each = var.env == "perftest" ? toset(["import"]) : toset([])
  to       = module.azurerm_key_vault_secret.case_creation_subscription_key
  id       = "https://fis-kv-perftest.vault.azure.net/secrets/courtnav-subscription-sub-key/43b83fe942ea446c91777cfbcff2a638"
}

import {
  for_each = var.env == "perftest" ? toset(["import"]) : toset([])
  to       = module.azurerm_key_vault_secret.document_subscription_key
  id       = "https://fis-kv-perftest.vault.azure.net/secrets/document-subscription-sub-key/0b08e836176646cb9a1adfed73dc50ce"
}