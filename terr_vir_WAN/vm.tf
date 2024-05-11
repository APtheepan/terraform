

resource "azurerm_network_interface" "nic_vm_region1" {
  name                = "nic_vm_${var.regions.region1.location}"
  resource_group_name = azurerm_resource_group.rg_regions["region1"].name
  location            = var.regions.region1.location
  ip_configuration {
    name                          = "Internal"
    subnet_id                     = azurerm_subnet.subnet_vm_region1.id
    private_ip_address_allocation = "Dynamic"
  }
  tags = {
    Environment = var.environment_tag
  }
}

resource "azurerm_network_interface" "nic_vm_region2" {
  name                = "nic_vm_${var.regions.region2.location}"
  resource_group_name = azurerm_resource_group.rg_regions["region2"].name
  location            = var.regions.region2.location
  ip_configuration {
    name                          = "Internal"
    subnet_id                     = azurerm_subnet.subnet_vm_region2.id
    private_ip_address_allocation = "Dynamic"
  }
  tags = {
    Environment = var.environment_tag
  }
}

resource "azurerm_windows_virtual_machine" "vm_region1" {
  name                  = "vm-region1-${var.regions.region1.location}01"
  resource_group_name   = azurerm_resource_group.rg_regions["region1"].name
  location              = var.regions.region1.location
  size                  = var.vm_size
  admin_username        = var.admin_username
  admin_password        = azurerm_key_vault_secret.vm_password.value
  network_interface_ids = [azurerm_network_interface.nic_vm_region1.id]
  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }
  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2022-Datacenter"
    version   = "latest"
  }
  tags = {
    environment = var.environment_tag
  }

}

resource "azurerm_windows_virtual_machine" "vm_region2" {
  name                  = "vm-region2-${var.regions.region1.location}01"
  resource_group_name   = azurerm_resource_group.rg_regions["region2"].name
  location              = var.regions.region2.location
  size                  = var.vm_size
  admin_username        = var.admin_username
  admin_password        = azurerm_key_vault_secret.vm_password.value
  network_interface_ids = [azurerm_network_interface.nic_vm_region2.id]
  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }
  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2022-Datacenter"
    version   = "latest"
  }
  tags = {
    environment = var.environment_tag
  }

}


