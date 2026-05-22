# ============================================================
# Outputs — azure-api-ingestion-lab
# ============================================================

output "resource_group_name" {
  description = "Name of the created Resource Group."
  value       = module.resource_group.resource_group_name
}

output "storage_account_name" {
  description = "Name of the created Storage Account."
  value       = module.adls.storage_account_name
}

output "primary_dfs_endpoint" {
  description = "Primary DFS endpoint for ADLS Gen2."
  value       = module.adls.primary_dfs_endpoint
}

output "data_factory_name" {
  description = "Name of the created Data Factory."
  value       = module.adf.data_factory_name
}

output "data_factory_principal_id" {
  description = "Principal ID of the ADF System Assigned Identity."
  value       = module.adf.data_factory_principal_id
}

output "key_vault_name" {
  description = "Name of the created Key Vault."
  value       = module.key_vault.key_vault_name
}

output "key_vault_uri" {
  description = "URI of the created Key Vault."
  value       = module.key_vault.key_vault_uri
}