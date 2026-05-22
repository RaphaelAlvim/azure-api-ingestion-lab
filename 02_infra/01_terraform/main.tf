# ============================================================
# Main — azure-api-ingestion-lab
# ============================================================

data "azurerm_client_config" "current" {}

resource "random_string" "suffix" {
  length  = 4
  upper   = false
  special = false
}

module "resource_group" {
  source = "./modules/resource_group"

  project_name = var.project_name
  environment  = var.environment
  location     = var.location
  tags         = var.tags
}

module "adls" {
  source = "./modules/adls"

  project_name        = var.project_name
  environment         = var.environment
  suffix              = random_string.suffix.result
  resource_group_name = module.resource_group.resource_group_name
  location            = module.resource_group.location
  containers          = var.storage_containers
  adf_principal_id    = module.adf.data_factory_principal_id
  tags                = var.tags
}

module "adf" {
  source = "./modules/adf"

  project_name        = var.project_name
  environment         = var.environment
  resource_group_name = module.resource_group.resource_group_name
  location            = module.resource_group.location
  tags                = var.tags
}

module "key_vault" {
  source = "./modules/key_vault"

  project_name        = var.project_name
  environment         = var.environment
  resource_group_name = module.resource_group.resource_group_name
  location            = module.resource_group.location
  adf_principal_id    = module.adf.data_factory_principal_id
  tags                = var.tags
}