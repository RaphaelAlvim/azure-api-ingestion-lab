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

  github_configuration {
    account_name       = var.github_account_name
    branch_name        = "main"
    git_url            = "https://github.com"
    publishing_enabled = true
    repository_name    = var.github_repository_name
    root_folder        = "/02_infra/02_data_factory"
  }

  tags = var.tags
}