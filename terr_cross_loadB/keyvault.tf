data "azurerm_client_config" "current" {}
/*
data "azuread_service_principal" "current" {
  client_id = data.azurerm_client_config.current.client_id
}
*/
resource "random_id" "kv_name" {
  byte_length = 6
  prefix      = "kv"
}
resource "azurerm_key_vault" "kv1" {
  name                        = random_id.kv_name.hex
  location                    = azurerm_resource_group.rg-sec.location
  resource_group_name         = azurerm_resource_group.rg-sec.name
  enabled_for_disk_encryption = true
  tenant_id                   = data.azurerm_client_config.current.tenant_id
  soft_delete_retention_days  = 7
  purge_protection_enabled    = false

  sku_name = "standard"

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


resource "random_password" "vmpassword" {
  length  = 20
  special = true
}

resource "azurerm_key_vault_secret" "vmpassword" {
  name         = "vmpassword"
  value        = random_password.vmpassword.result # check this later
  key_vault_id = azurerm_key_vault.kv1.id

}


