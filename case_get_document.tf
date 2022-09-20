module "case-document-mgmt-product" {
  source = "git@github.com:hmcts/cnp-module-api-mgmt-product?ref=master"

  api_mgmt_name = local.api_mgmt_name
  api_mgmt_rg   = local.api_mgmt_rg
  name = var.document_product_name
  product_access_control_groups = ["developers"]
  approval_required     = "false"
  subscription_required = "true"
  providers     = {
    azurerm = azurerm.aks-cftapps
  }
}

module "case-document-mgmt-api" {
  source = "git@github.com:hmcts/cnp-module-api-mgmt-api?ref=master"

  api_mgmt_name = local.api_mgmt_name
  api_mgmt_rg   = local.api_mgmt_rg
  revision      = "1"
  service_url   = local.prl_api_url
  product_id    = module.case-document-mgmt-product.product_id
  name          = join("-", [var.document_product_name, "api"])
  display_name  = "get case document api"
  path          = "prl-cos-api"
  protocols     = ["http", "https"]
  swagger_url   = "https://raw.githubusercontent.com/hmcts/reform-api-docs/master/docs/specs/cafcass-case-get-document.json"

  providers     = {
    azurerm = azurerm.aks-cftapps
  }
}

data "template_file" "case_document_policy_template" {
  template = file(join("", [path.module, "/template/api-policy.xml"]))

  vars = {
    s2s_client_id                   = data.azurerm_key_vault_secret.s2s_client_id.value
    s2s_client_secret               = data.azurerm_key_vault_secret.s2s_client_secret.value
    s2s_base_url                    = local.s2sUrl
  }
}

module "prl-case-document-policy" {
  source = "git@github.com:hmcts/cnp-module-api-mgmt-api-policy?ref=master"

  api_mgmt_name = local.api_mgmt_name
  api_mgmt_rg   = local.api_mgmt_rg

  api_name               = module.case-document-mgmt-api.name
  api_policy_xml_content = data.template_file.case_document_policy_template.rendered

  providers     = {
    azurerm = azurerm.aks-cftapps
  }
}

resource "azurerm_api_management_subscription" "case_document_subscription" {
  api_management_name = local.api_mgmt_name
  resource_group_name = local.api_mgmt_rg
  user_id             = azurerm_api_management_user.case_creation_user.id
  product_id          = module.case-document-mgmt-product.id
  display_name        = "Case Document subscription"
  state               = "active"
  provider            = azurerm.aks-cftapps

}

resource "azurerm_key_vault_secret" "case_document_subscription_key" {
  name         = "case-document-subscription-sub-key"
  value        = azurerm_api_management_subscription.case_document_subscription.primary_key
  key_vault_id = data.azurerm_key_vault.fis_key_vault.id
}
