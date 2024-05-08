resource "azurerm_virtual_network" "vnet_conn" {
  for_each            = var.regions
  name                = "vnet-${each.value.location}-conn"
  location            = each.value.location
  resource_group_name = azurerm_resource_group.rg-con[each.key].name
  address_space       = [each.value.cidr]
}


resource "azurerm_subnet" "subnet_conn" {
  for_each             = var.regions
  name                 = "subnet-${each.value.location}-conn"
  resource_group_name  = azurerm_resource_group.rg-con[each.key].name
  virtual_network_name = azurerm_virtual_network.vnet_conn[each.key].name
  address_prefixes     = [cidrsubnet(each.value.cidr, 2, 0)]
}

resource "azurerm_network_security_group" "nsg" {
  for_each            = var.regions
  name                = "nag-${each.value.location}-conn"
  location            = each.value.location
  resource_group_name = azurerm_resource_group.rg-con[each.key].name # Just need to check with each.value ** remember

}


resource "azurerm_network_security_rule" "nsr_conn" {
  for_each                    = var.regions
  name                        = "AllowInternetInbound"
  priority                    = 100
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "*"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.rg-con[each.key].name
  network_security_group_name = azurerm_network_security_group.nsg[each.key].name
}


resource "azurerm_subnet_network_security_group_association" "nsg-assocation" {
  for_each                  = var.regions
  subnet_id                 = azurerm_subnet.subnet_conn[each.key].id
  network_security_group_id = azurerm_network_security_group.nsg[each.key].id

}






