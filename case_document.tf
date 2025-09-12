module "document-mgmt-product" {
  source = "git@github.com:hmcts/cnp-module-api-mgmt-product?ref=master"

  api_mgmt_name                 = local.api_mgmt_name
  api_mgmt_rg                   = local.api_mgmt_rg
  name                          = var.document_product_name
  product_access_control_groups = ["developers"]
  approval_required             = "false"
  subscription_required         = "true"
  providers = {
    azurerm = azurerm.aks-cftapps
  }
}

module "document-mgmt-api" {
  source = "git@github.com:hmcts/cnp-module-api-mgmt-api?ref=master"

  api_mgmt_name = local.api_mgmt_name
  api_mgmt_rg   = local.api_mgmt_rg
  revision      = "1"
  service_url   = local.prl_api_url
  product_id    = module.document-mgmt-product.product_id
  name          = "${var.document_product_name}-api"
  display_name  = "Case document api"
  path          = "prl-document-api"
  protocols     = ["http", "https"]
  swagger_url   = "https://raw.githubusercontent.com/hmcts/reform-api-docs/master/docs/specs/prl_document_upload.json"

  providers = {
    azurerm = azurerm.aks-cftapps
  }
}

data "template_file" "document_policy_template" {
  template = file(join("", [path.module, "/template/api-policy.xml"]))

  vars = {
    s2s_client_id     = data.azurerm_key_vault_secret.s2s_client_id.value
    s2s_client_secret = data.azurerm_key_vault_secret.s2s_client_secret.value
    s2s_base_url      = local.s2sUrl
  }
}

module "prl-document-policy" {
  source = "git@github.com:hmcts/cnp-module-api-mgmt-api-policy?ref=master"

  api_mgmt_name = local.api_mgmt_name
  api_mgmt_rg   = local.api_mgmt_rg

  api_name               = module.document-mgmt-api.name
  api_policy_xml_content = data.template_file.document_policy_template.rendered

  providers = {
    azurerm = azurerm.aks-cftapps
  }
}

resource "azurerm_api_management_subscription" "document_subscription" {
  api_management_name = local.api_mgmt_name
  resource_group_name = local.api_mgmt_rg
  product_id          = module.document-mgmt-product.id
  display_name        = "Document subscription"
  state               = "active"
  provider            = azurerm.aks-cftapps

}

resource "azurerm_key_vault_secret" "document_subscription_key" {
  name         = "document-subscription-sub-key"
  value        = azurerm_api_management_subscription.document_subscription.primary_key
  key_vault_id = data.azurerm_key_vault.fis_key_vault.id
}

resource "azurerm_api_management_subscription" "cafcass_document_subscription" {
  api_management_name = local.api_mgmt_name
  resource_group_name = local.api_mgmt_rg
  product_id          = module.document-mgmt-product.id
  display_name        = "Cafcass Document subscription"
  state               = "active"
  provider            = azurerm.aks-cftapps

}

resource "azurerm_key_vault_secret" "cafcass_document_subscription_key" {
  name         = "cafcass-safeguarding-document-subscription-sub-key"
  value        = azurerm_api_management_subscription.cafcass_document_subscription.primary_key
  key_vault_id = data.azurerm_key_vault.fis_key_vault.id
}


# Configure Application insights logging for API
# Terraform doesn't currently provide an azurerm_api_management_logger data source, so instead of using
# the value of an output variable for the api_management_logger_id parameter it has to be set explicitly.
resource "azurerm_api_management_api_diagnostic" "api_mgmt_api_diagnostic" {
  identifier               = "applicationinsights"
  api_management_logger_id = "/subscriptions/${var.aks_subscription_id}/resourceGroups/${local.api_mgmt_rg}/providers/Microsoft.ApiManagement/service/${local.api_mgmt_name}/loggers/${local.api_mgmt_logger_name}"
  api_management_name      = local.api_mgmt_name
  api_name                 = module.document-mgmt-api.name
  resource_group_name      = local.api_mgmt_rg
  provider                 = azurerm.aks-cftapps

  sampling_percentage       = 100.0
  always_log_errors         = true
  log_client_ip             = true
  verbosity                 = "verbose"
  http_correlation_protocol = "W3C"

  frontend_request {
    body_bytes = 8192
    headers_to_log = [
      "content-type",
      "content-length",
      "origin"
    ]
  }

  frontend_response {
    body_bytes = 8192
  }
}
