provider "azurerm" {
  features {}
}

terraform {
  backend "azurerm" {}
  required_providers {
    azurerm = {
      source                = "hashicorp/azurerm"
      version               = "3.10.0"
      configuration_aliases = [azurerm.aks-cftapps]
    }

    azuread = {
      source  = "hashicorp/azuread"
      version = "1.6.0"
    }
  }
}
