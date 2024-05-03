terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>3.0"
    }
  }
}

provider "azurerm" {
  features {}
}

resource "random_string" "resource_code" {
  length  = 5
  special = false
  upper   = false
}
resource "azurerm_resource_group" "webapp-rg" {
  name     = "webapp-rg"
  location = "East US"
  tags = {
    environment = "Stage"
  }
}

resource "azurerm_storage_account" "webappsa" {
  name                     = "webappsa${random_string.resource_code.result}"
  resource_group_name      = azurerm_resource_group.webapp-rg.name
  location                 = azurerm_resource_group.webapp-rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"


  tags = {
    environment = "stage"
  }
}

resource "azurerm_storage_container" "webapp-tfstate" {
  name                  = "webapp-tfstate"
  storage_account_name  = azurerm_storage_account.webappsa.name
  container_access_type = "private"
}

