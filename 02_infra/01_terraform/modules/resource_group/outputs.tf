# ============================================================
# Outputs — module: resource_group
# ============================================================

output "resource_group_name" {
  description = "Name of the created Resource Group."
  value       = azurerm_resource_group.this.name
}

output "location" {
  description = "Location of the created Resource Group."
  value       = azurerm_resource_group.this.location
}