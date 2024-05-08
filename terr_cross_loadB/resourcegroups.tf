
resource "azurerm_resource_group" "rg-con" {
  for_each = var.regions
  location = each.value.location
  name     = "rg-${each.value.location}-con"

}

resource "azurerm_resource_group" "rg-host" {
  for_each = var.regions
  location = each.value.location
  name     = "rg-${each.value.location}-host"

}

resource "azurerm_resource_group" "rg-sec" {
  name     = "rg-${var.regions.region1.location}-sec"
  location = var.regions.region1.location
}







