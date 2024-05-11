resource "azurerm_virtual_wan" "vWAN" {
    name                = "vWAN-01"
    resource_group_name = azurerm_resource_group.rg_regions["region1"].name
    location            = var.regions.region1.location
    type                = "Standard"
    tags = {
    Environment = var.environment_tag
    }
   
}

resource "azurerm_virtual_hub" "vhub1_region1" {
    name                = "vhub1_region1"
    resource_group_name = azurerm_resource_group.rg_regions["region1"].name
    location            = var.regions.region1.location
    virtual_wan_id      = azurerm_virtual_wan.vWAN.id
    address_prefix      = var.regions.region1.virtual_wan_hub_prefix
  
}


resource "azurerm_virtual_hub" "vhub1_region2" {
    name                = "vhub2_region2"
    resource_group_name = azurerm_resource_group.rg_regions["region2"].name
    location            = var.regions.region2.location
    virtual_wan_id      = azurerm_virtual_wan.vWAN.id
    address_prefix      = var.regions.region2.virtual_wan_hub_prefix
  
}

resource "azurerm_virtual_hub_connection" "vhub1_region1_connection" {
  name                      = "vhub1_region1_connection"
  virtual_hub_id            = azurerm_virtual_hub.vhub1_region1.id
  remote_virtual_network_id = azurerm_virtual_network.vnet["region1"].id
}


resource "azurerm_virtual_hub_connection" "vhub1_region1_connection" {
  name                      = "vhub1_region1_connection"
  virtual_hub_id            = azurerm_virtual_hub.vhub1_region1.id
  remote_virtual_network_id = azurerm_virtual_network.vnet["region2"].id
}


