# ============================================================
# Module: azure_sql
# ============================================================

resource "random_string" "sql_suffix" {
  length  = 4
  upper   = false
  special = false
}

resource "azurerm_mssql_server" "this" {
  name                         = "sql-${var.project_name}-${var.environment}-we"
  resource_group_name          = var.resource_group_name
  location                     = var.location
  version                      = "12.0"
  administrator_login          = var.sql_admin_login
  administrator_login_password = var.sql_admin_password

  tags = var.tags
}

resource "azurerm_mssql_database" "this" {
  name      = "sqldb-pipeline-control"
  server_id = azurerm_mssql_server.this.id
  sku_name  = "Basic"

  tags = var.tags
}

resource "azurerm_mssql_firewall_rule" "azure_services" {
  name             = "AllowAzureServices"
  server_id        = azurerm_mssql_server.this.id
  start_ip_address = "0.0.0.0"
  end_ip_address   = "0.0.0.0"
}