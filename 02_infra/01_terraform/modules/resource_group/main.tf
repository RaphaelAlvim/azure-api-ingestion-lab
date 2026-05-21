# ============================================================
# Module: resource_group
# ============================================================

resource "azurerm_resource_group" "this" {
  name     = "rg-${var.project_name}-${var.environment}-we"
  location = var.location
  tags     = var.tags
}