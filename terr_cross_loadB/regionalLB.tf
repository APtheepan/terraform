
resource "random_id" "dns-name" {
  byte_length = 4
}

resource "azurerm_public_ip" "pipr_lb" {
  for_each            = var.regions
  name                = "pip-${each.value.location}-lb"
  location            = each.value.location
  resource_group_name = azurerm_resource_group.rg-con[each.key].name
  allocation_method   = "Static"
  sku                 = "Standard"
  domain_name_label   = "lb-${each.value.location}-${random_id.dns-name.hex}" #check this with outputfile 

}
resource "azurerm_lb" "region_lb" {
  for_each            = var.regions
  name                = "region-${each.value.location}-lb"
  location            = each.value.location
  resource_group_name = azurerm_resource_group.rg-con[each.key].name
  sku                 = "Standard"

  frontend_ip_configuration {
    name                 = "PublicIPAddress"
    public_ip_address_id = azurerm_public_ip.pipr_lb[each.key].id
  }

}

resource "azurerm_lb_probe" "regional-lb-probe" {
  for_each        = var.regions
  loadbalancer_id = azurerm_lb.region_lb[each.key].id
  name            = "probe"
  port            = 80
  protocol        = "Http"
  request_path    = "/"
}


resource "azurerm_lb_backend_address_pool" "regional-lb-pool" {
  for_each        = var.regions
  loadbalancer_id = azurerm_lb.region_lb[each.key].id
  name            = "BackEndAddressPool"
}

resource "azurerm_lb_rule" "regionlb_rule" {
  for_each                       = var.regions
  loadbalancer_id                = azurerm_lb.region_lb[each.key].id
  name                           = "regionLBRule"
  protocol                       = "Tcp"
  frontend_port                  = 80
  backend_port                   = 80
  frontend_ip_configuration_name = azurerm_lb.region_lb[each.key].frontend_ip_configuration[0].name
  backend_address_pool_ids       = [azurerm_lb_backend_address_pool.regional-lb-pool[each.key].id]

}

resource "azurerm_network_interface_backend_address_pool_association" "region-association" {
  for_each                = var.regions
  network_interface_id    = azurerm_network_interface.nic_host[each.key].id
  backend_address_pool_id = azurerm_lb_backend_address_pool.regional-lb-pool[each.key].id
  ip_configuration_name   = "Internal"


}




