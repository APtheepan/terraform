resource "azurerm_public_ip" "regional-bastion-pip" {
  for_each            = var.regions
  name                = "${each.value.location}-bastion-pip"
  location            = each.value.location
  resource_group_name = azurerm_resource_group.rg_regions[each.key].name
  allocation_method   = "Static"
  sku                 = "Standard"
  tags = {
    Environment = var.environment_tag
  }
}

resource "azurerm_bastion_host" "region1-bastion" {
  name                = "${var.regions.region1.location}-bastion"
  location            = var.regions.region1.location
  resource_group_name = azurerm_resource_group.rg_regions["region1"].name
  ip_configuration {
    name                 = "${var.regions.region1.location}-bastion-ipconfig"
    public_ip_address_id = azurerm_public_ip.regional-bastion-pip["region1"].id
    subnet_id            = azurerm_subnet.vnet_subnet_region1_bastion.id
  }
}


resource "azurerm_bastion_host" "region2-bastion" {
  name                = "${var.regions.region2.location}-bastion"
  location            = var.regions.region2.location
  resource_group_name = azurerm_resource_group.rg_regions["region2"].name
  ip_configuration {
    name                 = "${var.regions.region2.location}-bastion-ipconfig"
    public_ip_address_id = azurerm_public_ip.regional-bastion-pip["region2"].ip
    subnet_id            = azurerm_subnet.vnet_subnet_region2_bastion.id
  }
}
