# Obtain the subscription ID of the problematic resource
data "azurerm_subscription" "current" {}

import {
  # Run this import only in prod
  for_each = var.env == "demo" ? toset(["import"]) : toset([])
  # Specify the resource address to import to
  to = azurerm_api_management_subscription.resource_group_name
  # Specify the resource ID to import from
  id = "/subscriptions/d025fece-ce99-4df2-b7a9-b649d3ff2060/resourceGroups/cft-demo-network-rg/providers/Microsoft.ApiManagement/service/cft-api-mgmt-demo/products/document"
}

import {
  # Run this import only in prod
  for_each = var.env == "demo" ? toset(["import"]) : toset([])
  # Specify the resource address to import to
  to = azurerm_api_management_subscription.resource_group_name
  # Specify the resource ID to import from
  id = "/subscriptions/d025fece-ce99-4df2-b7a9-b649d3ff2060/resourceGroups/cft-demo-network-rg/providers/Microsoft.ApiManagement/service/cft-api-mgmt-demo/apis/case-api"
}