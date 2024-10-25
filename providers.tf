terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "4.4.0"
    }
    external = {
      source  = "hashicorp/external"
      version = "2.3.3"
    }
    # azapi = {
    #   source  = "Azure/azapi"
    #   version = "1.13.1"
    # }
  }
  backend "azurerm" {
    resource_group_name  = "sa1_test_eic_ShivModi"
    storage_account_name = "12345mystorage"
    container_name       = "mycontainer"
    key                  = "propel.terraform.tfstate"

  }
}
provider "azurerm" {
  features {}
  subscription_id                 = "664b6097-19f2-42a3-be95-a4a6b4069f6b"
  resource_provider_registrations = "none"
}