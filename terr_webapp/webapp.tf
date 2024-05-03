terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=3.0.0"
    }
  }
}
provider "azurerm" {
  skip_provider_registration = true # This is only required when the User, Service Principal, or Identity running Terraform lacks the permissions to register Azure Resource Providers.
  features {}
}


resource "azurerm_resource_group" "webapp-rg" {
  name = "webapp-rg"
  location = "East US"
}

resource "azurerm_virtual_network" "webapp-vn" {
  name = "webapp-vn"
  resource_group_name = azurerm_resource_group.webapp-rg.name
  location = azurerm_resource_group.webapp-rg.location
  address_space = ["10.123.0.0/16"]
  
}
resource "azurerm_subnet" "webapp-sb" {
  name = "webapp-sb"
  resource_group_name = azurerm_resource_group.webapp-rg.name
  virtual_network_name = azurerm_virtual_network.webapp-vn.name
  address_prefixes = ["10.123.0.0/24"]
}

resource "azurerm_network_interface" "webapp-nic-1" {
  name = "webapp-nic-1" 
  location = azurerm_resource_group.webapp-rg.location
  resource_group_name = azurerm_resource_group.webapp-rg.name
  ip_configuration {
    name = "Internal-1"
    subnet_id = azurerm_subnet.webapp-sb.id
    private_ip_address_allocation = "Dynamic"
  }  
}

resource "azurerm_network_interface" "webapp-nic-2" {
  name = "webapp-nic-2" 
  location = azurerm_resource_group.webapp-rg.location
  resource_group_name = azurerm_resource_group.webapp-rg.name
  ip_configuration {
    name = "Internal-2"
    subnet_id = azurerm_subnet.webapp-sb.id
    private_ip_address_allocation = "Dynamic"
  }  
}

/*
resource "azurerm_storage_account" "webapp-sa" {
  name                     = "webapp-sa"
  resource_group_name      = azurerm_resource_group.webapp-rg.name
  location                 = azurerm_resource_group.webapp-rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}


resource "azurerm_storage_container" "webapp-sc" {
  name                  = "webapp-sc"
  storage_account_name  = azurerm_storage_account.webapp-sa.name
  container_access_type = "private"
}
*/


resource "azurerm_availability_set" "webapp_vm_as" {
  name                = "webapp_vm_as"
  location            = azurerm_resource_group.webapp-rg.location
  resource_group_name = azurerm_resource_group.webapp-rg.name
}

resource "azurerm_linux_virtual_machine" "webapp-vm1" {
  name                = "webapp-vm1"
  resource_group_name = azurerm_resource_group.webapp-rg.name
  location            = azurerm_resource_group.webapp-rg.location
  size                = "Standard_F2"
  disable_password_authentication = "false"
  admin_username      = "adminuser"
  admin_password      = "Admintheepu1"
  availability_set_id = azurerm_availability_set.webapp_vm_as.id
  network_interface_ids = [ azurerm_network_interface.webapp-nic-1.id ]
  os_disk {
  caching = "ReadWrite"
  storage_account_type = "Standard_LRS"
  }
  user_data = filebase64("vm1.sh")
    source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }
}

resource "azurerm_linux_virtual_machine" "webapp-vm2" {
  name                = "webapp-vm2"
  resource_group_name = azurerm_resource_group.webapp-rg.name
  location            = azurerm_resource_group.webapp-rg.location
  size                = "Standard_F2"
  disable_password_authentication = "false"
  admin_username      = "adminuser"
  admin_password      = "Admintheepu1"
  availability_set_id = azurerm_availability_set.webapp_vm_as.id
  network_interface_ids = [ azurerm_network_interface.webapp-nic-2.id ]
  os_disk {
  caching = "ReadWrite"
  storage_account_type = "Standard_LRS"
  }
  user_data = filebase64("vm2.sh")
    source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }
}




