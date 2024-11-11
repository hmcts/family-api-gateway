# Obtain the subscription ID of the problematic resource
data "azurerm_subscription" "current" {}

import {
  # Run this import only in prod
  for_each = var.env == "demo" ? toset(["import"]) : toset([])
  # Specify the resource address to import to
  to = module.document-mgmt-api.azurerm_api_management_api.api
  # Specify the resource ID to import from
  id = "/subscriptions/d025fece-ce99-4df2-b7a9-b649d3ff2060/resourceGroups/cft-demo-network-rg/providers/Microsoft.ApiManagement/service/cft-api-mgmt-demo/apis"
}

import {
  # Run this import only in prod
  for_each = var.env == "demo" ? toset(["import"]) : toset([])
  # Specify the resource address to import to
  to = module.case-mgmt-api.azurerm_api_management_api.api
  # Specify the resource ID to import from
  id = "/subscriptions/d025fece-ce99-4df2-b7a9-b649d3ff2060/resourceGroups/cft-demo-network-rg/providers/Microsoft.ApiManagement/service/cft-api-mgmt-demo/apis/case-api"
}

import {
  # Run this import only in prod
  for_each = var.env == "demo" ? toset(["import"]) : toset([])
  # Specify the resource address to import to
  to = module.document-mgmt-product.azurerm_api_management_product_group.access_control_groups["developers"]
  # Specify the resource ID to import from
  id = "/subscriptions/d025fece-ce99-4df2-b7a9-b649d3ff2060/resourceGroups/cft-demo-network-rg/providers/Microsoft.ApiManagement/service/cft-api-mgmt-demo/products/document/groups/developers"
}

import {
  # Run this import only in prod
  for_each = var.env == "demo" ? toset(["import"]) : toset([])
  # Specify the resource address to import to
  to = module.case-document-mgmt-product.azurerm_api_management_product.product
  # Specify the resource ID to import from
  id = "/subscriptions/d025fece-ce99-4df2-b7a9-b649d3ff2060/resourceGroups/cft-demo-network-rg/providers/Microsoft.ApiManagement/service/cft-api-mgmt-demo/products"
}

import {
  # Run this import only in prod
  for_each = var.env == "demo" ? toset(["import"]) : toset([])
  # Specify the resource address to import to
  to = module.case-document-mgmt-api.azurerm_api_management_api.api
  # Specify the resource ID to import from
  id = "/subscriptions/d025fece-ce99-4df2-b7a9-b649d3ff2060/resourceGroups/cft-demo-network-rg/providers/Microsoft.ApiManagement/service/cft-api-mgmt-demo/apis/fis-document-get-api"
}

import {
  # Run this import only in prod
  for_each = var.env == "demo" ? toset(["import"]) : toset([])
  # Specify the resource address to import to
  to = module.api-case-mgmt-product.azurerm_api_management_product.product
  # Specify the resource ID to import from
  id = "/subscriptions/d025fece-ce99-4df2-b7a9-b649d3ff2060/resourceGroups/cft-demo-network-rg/providers/Microsoft.ApiManagement/service/cft-api-mgmt-demo/products/case"
}