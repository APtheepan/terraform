resource "azurerm_resource_group" "rg_regions" {
  for_each = var.regions
  name     = "rg-${each.value.location}-vWAN"
  location = each.value.location
  tags = {
    environment = var.environment_tag
  }
}
