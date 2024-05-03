resource "azurerm_network_security_group" "webapp-nsg" {
    name = "webapp-nsg"
    location = azurerm_resource_group.webapp-rg.location
    resource_group_name = azurerm_resource_group.webapp-rg.name
}
resource "azurerm_network_security_rule" "webapp-nsr" {
  name                        = "webapp-nsr"
  priority                    = 100
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "80"
  destination_port_range      = "8080"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.webapp-rg.name
  network_security_group_name = azurerm_network_security_group.webapp-nsg.name
}

resource "azurerm_subnet_network_security_group_association" "webapp-nsga" {
  subnet_id                 = azurerm_subnet.webapp-sb.id
  network_security_group_id = azurerm_network_security_group.webapp-nsg.id
}


#resource "azurerm_network_security_group" "webapp-lb-sg" {
#  name = "webapp-lb-sg"
#  location = azurerm_resource_group.webapp-rg.location
#  resource_group_name = azurerm_resource_group.webapp-rg.name
#}

#resource "azurerm_network_security_rule" "webapp-lb-httpIN" {
#  name                        = "webapp-lb-httpIN"
# priority                    = 100
#  direction                   = "Inbound"
# access                      = "Allow"
#  protocol                    = "Tcp"
# source_port_range           = "80"
#  destination_port_range      = "80"
#  source_address_prefix       = "*"
#  destination_address_prefix  = "*"
#  resource_group_name         = azurerm_resource_group.webapp-rg.name
#  network_security_group_name = azurerm_network_security_group.webapp-lb-sg.name
#}
  
#resource "azurerm_network_security_rule" "webapp-lb-OUT" {
#  name                        = "webapp-lb-OUT"
#  priority                    = 100
#  direction                   = "Outbound"
#  access                      = "Allow"
#  protocol                    = "*"
#  source_port_range           = "*"
#  destination_port_range      = "*"
# source_address_prefix       = "*"
# destination_address_prefix  = "*"
#  resource_group_name         = azurerm_resource_group.webapp-rg.name
#  network_security_group_name = azurerm_network_security_group.webapp-lb-sg.name
#}



