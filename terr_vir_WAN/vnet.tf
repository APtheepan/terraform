resource "azurerm_virtual_network" "vnet" {
  for_each            = var.regions
  name                = "vnet-${each.key}"
  resource_group_name = azurerm_resource_group.rg_regions[each.key].name
  location            = azurerm_resource_group.rg_regions[each.key].location
  address_space       = [each.value.address_space]
  tags = {
    environment = var.environment_tag
  }

}

resource "azurerm_subnet" "vnet_subnet_region1_vm" {

  name                 = "subnet-${var.regions.region1.location}-vm"
  resource_group_name  = azurerm_resource_group.rg_regions["region1"].name
  virtual_network_name = azurerm_virtual_network.vnet_wan_spoke["region1"].name
  address_prefixes     = [var.vnet_subnet_region1_vm]
}

resource "azurerm_subnet" "vnet_subnet_region1_bastion" {

  name                 = "subnet-${var.regions.region1.location}-bastian"
  resource_group_name  = azurerm_resource_group.rg_regions["region1"].name
  virtual_network_name = azurerm_virtual_network.vnet_wan_spoke["region1"].name
  address_prefixes     = [var.vnet_subnet_region1_bastion]
}

resource "azurerm_subnet" "vnet_subnet_region2_vm" {

  name                 = "subnet-${var.regions.region2.location}-vm"
  resource_group_name  = azurerm_resource_group.rg_regions["region2"].name
  virtual_network_name = azurerm_virtual_network.vnet_wan_spoke["region2"].name
  address_prefixes     = [var.vnet_subnet_region2_vm]

}

resource "azurerm_subnet" "vnet_subnet_region2_bastion" {

  name                 = "subnet-${var.regions.region2.location}-bastion"
  resource_group_name  = azurerm_resource_group.rg_regions["region2"].name
  virtual_network_name = azurerm_virtual_network.vnet_wan_spoke["region2"].name
  address_prefixes     = [var.vnet_subnet_region2_bastion]

}


resource "azurerm_network_security_group" "vnet_nsg" {
  for_each            = var.regions
  name                = "nsg-${each.value.location}"
  location            = each.value.location
  resource_group_name = azurerm_resource_group.rg_regions[each.key].name
  tags = {
    environment = var.environment_tag
  }
}
resource "azurerm_network_security_rule" "nsg_rule_region1" {
  name                        = "nsg_rule_region1"
  priority                    = 100
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "*"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.rg_regions["region1"].name
  network_security_group_name = azurerm_network_security_group.vnet_nsg["region1"].name
}

resource "azurerm_network_security_rule" "nsg_rule_region2" {
  name                        = "nsg_rule_region2"
  priority                    = 100
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "*"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.rg_regions["region2"].name
  network_security_group_name = azurerm_network_security_group.vnet_nsg["region2"].name
}




resource "azurerm_subnet_network_security_group_association" "region1-vnet1-snet1" {
  subnet_id                 = azurerm_subnet.vnet_subnet_region1_vm.id
  network_security_group_id = azurerm_network_security_group.vnet_nsg["region1"].id
}

resource "azurerm_subnet_network_security_group_association" "region2-vnet1-snet1" {
  subnet_id                 = azurerm_subnet.vnet_subnet_region2_vm.id
  network_security_group_id = azurerm_network_security_group.vnet_nsg["region2"].id
}
