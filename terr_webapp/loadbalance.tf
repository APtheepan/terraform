
resource "azurerm_public_ip" "webapp-lb-publicIP" {
    name = "webapp-lb-publicIP-1"
    resource_group_name = azurerm_resource_group.webapp-rg.name
    allocation_method = "Dynamic"
    location = azurerm_resource_group.webapp-rg.location
  
}

resource "azurerm_lb" "webapp-lb" {
    name = "webapp-lb"
    resource_group_name = azurerm_resource_group.webapp-rg.name
    location = azurerm_resource_group.webapp-rg.location
    
    frontend_ip_configuration {
      name = "webapp-lb-front-publicIP"
      public_ip_address_id = azurerm_public_ip.webapp-lb-publicIP.id    
    }
}

resource "azurerm_lb_backend_address_pool" "webapp-lb-bap" {
    name = "webapp-lb-bap"
    loadbalancer_id = azurerm_lb.webapp-lb.id
    depends_on = [ azurerm_availability_set.webapp_vm_as,
                    azurerm_lb.webapp-lb    ]              
}

resource "azurerm_network_interface_backend_address_pool_association" "backendpool_association_1" {
    ip_configuration_name = "Internal-1"
    network_interface_id = azurerm_network_interface.webapp-nic-1.id
    backend_address_pool_id = azurerm_lb_backend_address_pool.webapp-lb-bap.id
   
}

resource "azurerm_network_interface_backend_address_pool_association" "backendpool_association_2" {
    ip_configuration_name = "Internal-2"
    network_interface_id = azurerm_network_interface.webapp-nic-2.id
    backend_address_pool_id = azurerm_lb_backend_address_pool.webapp-lb-bap.id
   
}

resource "azurerm_lb_rule" "webapp-lb-rule" {
   name = "webapp-lb-rule"
   protocol = "Tcp"
   loadbalancer_id = azurerm_lb.webapp-lb.id
   frontend_port = 80
   backend_port = 80
   frontend_ip_configuration_name = azurerm_lb.webapp-lb.frontend_ip_configuration[0].name
   depends_on = [ azurerm_availability_set.webapp_vm_as,
                    azurerm_lb.webapp-lb ]
}
