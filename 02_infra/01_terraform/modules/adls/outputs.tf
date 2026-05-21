# ============================================================
# Outputs — module: adls
# ============================================================

output "storage_account_name" {
  description = "Name of the created Storage Account."
  value       = azurerm_storage_account.this.name
}

output "storage_account_id" {
  description = "ID of the created Storage Account."
  value       = azurerm_storage_account.this.id
}

output "primary_dfs_endpoint" {
  description = "Primary DFS endpoint for ADLS Gen2."
  value       = azurerm_storage_account.this.primary_dfs_endpoint
}