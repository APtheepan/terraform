

data "azurerm_client_config" "current" {}

resource "azurerm_key_vault" "WAN_key_vault" {
  name                            = "WANKeyStore"
  location                        = var.regions.region1.location
  resource_group_name             = azurerm_resource_group.rg_regions["region1"].name
  tenant_id                       = data.azurerm_client_config.current.tenant_id
  sku_name                        = "standard"
  enabled_for_deployment          = true
  enabled_for_disk_encryption     = true
  enabled_for_template_deployment = true
  tags = {
    environment = var.environment_tag
  }
  access_policy {
    tenant_id = data.azurerm_client_config.current.tenant_id
    object_id = data.azurerm_client_config.current.object_id

    key_permissions = [
      "Get",
    ]

    secret_permissions = [
      "Get", "Backup", "Delete", "List", "Purge", "Recover", "Restore", "Set",
    ]

    storage_permissions = [
      "Get",
    ]
  }

}


resource "random_password" "vm_password" {
  length  = 15
  special = true
}

resource "azurerm_key_vault_secret" "vm_password" {
  name         = "vm_password"
  value        = random_password.vm_password.result
  key_vault_id = azurerm_key_vault.WAN_key_vault.id
  tags = {
    environment = var.environment_tag
  }
  depends_on = [azurerm_key_vault.WAN_key_vault]
}