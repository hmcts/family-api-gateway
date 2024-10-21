provider "azurerm" {
  features {}
}

terraform {
  backend "azurerm" {}
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "4.1.0"
    }

    azuread = {
      source  = "hashicorp/azuread"
      version = "2.33.0"
    }
  }
}
