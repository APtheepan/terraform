/*
resource "azurerm_dns_zone" "webapp_dz" {
    name = "webapp_dz"
    resource_group_name = azurerm_resource_group.webapp-rg.name
}


resource "azurerm_dns_a_record" "webapp_dnsar" {
  name                = "webapp_dnsar"
  zone_name           = azurerm_dns_zone.webapp_dz.name
  resource_group_name = azurerm_resource_group.webapp-rg.name
  ttl                 = 3600
  records             = [azurerm_public_ip.webapp-lb-publicIP.ip_address]
}
*/


