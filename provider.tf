terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.90"
    }
  }
  backend "azurerm" {}
}

provider "azurerm" {
  alias           = "source_sub"
  subscription_id = var.source_subscription_id
  features {}
}

provider "azurerm" {
  alias           = "dest_sub"
  subscription_id = var.dest_subscription_id
  features {}
}
