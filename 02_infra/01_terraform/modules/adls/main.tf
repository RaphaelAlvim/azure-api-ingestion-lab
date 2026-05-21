# ============================================================
# Module: adls
# ============================================================

resource "azurerm_storage_account" "this" {
  name                     = "st${var.project_name}${var.environment}${var.suffix}"
  resource_group_name      = var.resource_group_name
  location                 = var.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  account_kind             = "StorageV2"
  is_hns_enabled           = true

  tags = var.tags
}

resource "azurerm_storage_data_lake_gen2_filesystem" "this" {
  for_each           = toset(var.containers)
  name               = each.value
  storage_account_id = azurerm_storage_account.this.id
}