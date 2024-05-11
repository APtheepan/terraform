
resource "azurerm_public_ip" "pip_cr_lb" {

  name                = "pip_cr_lb"
  location            = var.regions.region1.location
  allocation_method   = "Static"
  resource_group_name = "rg-${var.regions.region1.location}-con" # check this in portal
  sku                 = "Standard"
  sku_tier            = "Global" # We difine here that this is the global level ip
  domain_name_label   = "lb-global-${random_id.dns-name.hex}"
  depends_on          = [azurerm_resource_group.rg-con]

}


resource "azurerm_lb" "cross-region-lb" {
  name                = "cross_lb_${var.regions.region1.location}"
  location            = var.regions.region1.location
  resource_group_name = "rg-${var.regions.region1.location}-con"
  sku                 = "Standard"
  sku_tier            = "Global"
  frontend_ip_configuration {
    name                 = "Fr_Pub_LBIP"
    public_ip_address_id = azurerm_public_ip.pip_cr_lb.id
  }

}

resource "azurerm_lb_backend_address_pool" "cross-region-lb-pool" {
  loadbalancer_id = azurerm_lb.cross-region-lb.id
  name            = "BackEndAddressPool"
}

resource "azurerm_lb_backend_address_pool_address" "cross-region-lb-pool-address" {
  for_each                            = var.regions
  name                                = "cross-region-lb-${each.value.location}"
  backend_address_pool_id             = azurerm_lb_backend_address_pool.cross-region-lb-pool.id
  backend_address_ip_configuration_id = azurerm_lb.region_lb[each.key].frontend_ip_configuration[0].id
}

resource "azurerm_lb_rule" "cross-region-lb-rule" {
  loadbalancer_id                = azurerm_lb.cross-region-lb.id
  name                           = "LBRule"
  protocol                       = "Tcp"
  frontend_port                  = 80
  backend_port                   = 80
  frontend_ip_configuration_name = azurerm_lb.cross-region-lb.frontend_ip_configuration[0].name
  backend_address_pool_ids       = [azurerm_lb_backend_address_pool.cross-region-lb-pool.id]
}





