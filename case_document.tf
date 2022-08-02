module "prl-document-product" {
  source = "git@github.com:hmcts/cnp-module-api-mgmt-product?ref=master"

  api_mgmt_name = local.api_mgmt_name
  api_mgmt_rg   = local.api_mgmt_rg
  name = var.product_name
  product_access_control_groups = ["developers"]
  
  providers = {
    azurerm = azurerm.cftappsdemo
  }
}

module "prl-document-api" {
  source = "git@github.com:hmcts/cnp-module-api-mgmt-api?ref=master"

  api_mgmt_name = local.api_mgmt_name
  api_mgmt_rg   = local.api_mgmt_rg
  revision      = "1"
  service_url   = local.prl_api_url
  product_id    = module.prl-document-product.product_id
  name          = join("-", [var.product_name, "api"])
  display_name  = "Case document api"
  path          = "prl-case-api"
  swagger_url   = "https://raw.githubusercontent.com/hmcts/reform-api-docs/master/docs/specs/court_nav.json"
  
  depends_on = [
    module.prl-document-product
  ]
  providers = {
    azurerm = azurerm.cftappsdemo
  }
}

data "template_file" "document_policy_template" {
  template = file(join("", [path.module, "/template/api-policy.xml"]))

  vars = {
    s2s_client_id                   = data.azurerm_key_vault_secret.s2s_client_id.value
    s2s_client_secret               = data.azurerm_key_vault_secret.s2s_client_secret.value
    s2s_base_url                    = local.s2sUrl
  }
}

module "prl-document-policy" {
  source = "git@github.com:hmcts/cnp-module-api-mgmt-api-policy?ref=master"

  api_mgmt_name = local.api_mgmt_name
  api_mgmt_rg   = local.api_mgmt_rg

  api_name               = module.prl-document-api.name
  api_policy_xml_content = data.template_file.document_policy_template.rendered
  
  providers = {
    azurerm = azurerm.cftappsdemo
  }
}

data "azurerm_api_management_product" "documentApi" {
  product_id          = module.prl-document-product.product_id
  api_management_name = local.api_mgmt_name
  resource_group_name = local.api_mgmt_rg

  provider = azurerm.cftappsdemo
}
  
resource "azurerm_api_management_subscription" "document_subscription" {
  api_management_name = local.api_mgmt_name
  resource_group_name = local.api_mgmt_rg
  user_id             = azurerm_api_management_user.courtnav_user.id
  product_id          = data.azurerm_api_management_product.documentApi.id
  display_name        = "Document subscription"
  state               = "active"

  provider = azurerm.cftappsdemo
}

resource "azurerm_key_vault_secret" "document_subscription_key" {
  name         = "document-subscription-sub-key"
  value        = azurerm_api_management_subscription.document_subscription.primary_key
  key_vault_id = data.azurerm_key_vault.fis_key_vault.id
}
