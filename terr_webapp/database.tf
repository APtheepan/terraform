
/*

resource "azurerm_postgresql_server" "webapp_ser_sql" {
  name                = "postgresql-server-1"
  location            = azurerm_resource_group.webapp-rg.location
  resource_group_name = azurerm_resource_group.webapp-rg.name

  sku_name = "B_Gen5_2"

  storage_mb                   = 5120
  backup_retention_days        = 7
  geo_redundant_backup_enabled = false
  auto_grow_enabled            = true

  administrator_login          = "psqladmin"
  administrator_login_password = "H@Sh1CoR3!"
  version                      = "9.5"
  ssl_enforcement_enabled      = true
}

resource "azurerm_postgresql_database" "webapp_db_instance" {
  name                = "webapp_db_instance"
  resource_group_name = azurerm_resource_group.webapp-rg.name
  server_name         = azurerm_postgresql_server.webapp_ser_sql.name
  charset             = "UTF8"
  collation           = "English_United States.1252"

  # prevent the possibility of accidental data loss
  lifecycle {
    prevent_destroy = false
  }
}

*/