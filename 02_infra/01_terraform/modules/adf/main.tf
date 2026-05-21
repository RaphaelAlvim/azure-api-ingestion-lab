# ============================================================
# Module: adf
# ============================================================

resource "azurerm_data_factory" "this" {
  name                = "adf-${var.project_name}-${var.environment}-we"
  resource_group_name = var.resource_group_name
  location            = var.location

  identity {
    type = "SystemAssigned"
  }

  tags = var.tags
}