# Provider block
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.0.0"
    }
  }
}

# Configure the Microsoft Azure Provider
provider "azurerm" {
  skip_provider_registration = "true"
  features {}
}

# Create a resource group
resource "azurerm_resource_group" "your_RG_name" {
  name     = var.rg_name
  location = var.location
  tags     = var.tags
}

resource "azurerm_virtual_network" "main_vnet" {
  name                = var.vnet_name
  location            = azurerm_resource_group.your_RG_name.location
  resource_group_name = azurerm_resource_group.your_RG_name.name
  address_space       = ["10.1.0.0/16"]

}

resource "azurerm_subnet" "main_vnet_subnets" {
  for_each             = var.subnets
  resource_group_name  = azurerm_resource_group.your_RG_name.name
  virtual_network_name = azurerm_virtual_network.main_vnet.name
  name                 = each.key
  address_prefixes     = each.value["address"]
}
