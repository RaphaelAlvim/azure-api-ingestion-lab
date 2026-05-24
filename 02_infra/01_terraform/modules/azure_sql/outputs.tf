# ============================================================
# Outputs — module: azure_sql
# ============================================================

output "sql_server_name" {
  description = "Name of the created SQL Server."
  value       = azurerm_mssql_server.this.name
}

output "sql_server_fqdn" {
  description = "Fully qualified domain name of the SQL Server."
  value       = azurerm_mssql_server.this.fully_qualified_domain_name
}

output "sql_database_name" {
  description = "Name of the created SQL Database."
  value       = azurerm_mssql_database.this.name
}