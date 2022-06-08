module "prl-courtnav-product" {
  source = "git@github.com:hmcts/cnp-module-api-mgmt-product?ref=master"

  api_mgmt_name = local.api_mgmt_name_cft
  api_mgmt_rg   = local.api_mgmt_rg_cft
  name = var.product_name
  product_access_control_groups = ["developers"]
}

module "prl-courtnav-api" {
  source = "git@github.com:hmcts/cnp-module-api-mgmt-api?ref=master"

  api_mgmt_name = local.api_mgmt_name_cft
  api_mgmt_rg   = local.api_mgmt_rg_cft
  revision      = "1"
  service_url   = local.prl_api_url
  product_id    = module.prl-courtnav-product.product_id
  name          = join("-", [var.product_name, "api"])
  display_name  = "Court Nav Api"
  path          = "prl-case-api"
  swagger_url   = "https://raw.githubusercontent.com/hmcts/reform-api-docs/master/docs/specs/ccpay-payment-app.list-status.json"
}

data "template_file" "courtnav_policy_template" {
  template = file(join("", [path.module, "/template/api-policy.xml"]))

  vars = {
    s2s_client_id                   = data.azurerm_key_vault_secret.s2s_client_id.value
    s2s_client_secret               = data.azurerm_key_vault_secret.s2s_client_secret.value
    s2s_base_url                    = local.s2sUrl
  }
}

module "prl-courtnav-policy" {
  source = "git@github.com:hmcts/cnp-module-api-mgmt-api-policy?ref=master"

  api_mgmt_name = local.api_mgmt_name_cft
  api_mgmt_rg   = local.api_mgmt_rg_cft

  api_name               = module.prl-courtnav-api.name
  //api_policy_xml_content = data.template_file.refund_status_policy_template.rendered
}

data "azurerm_api_management" "courtnav" {
  name                = var.product_name
  resource_group_name = local.api_mgmt_rg_cft
}

data "azurerm_api_management_product" "courtnav" {
  product_id          = module.prl-courtnav-product.product_id
  api_management_name = data.azurerm_api_management.courtnav.name
  resource_group_name = data.azurerm_api_management.courtnav.resource_group_name
}

