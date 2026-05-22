# ============================================================
# Variables — module: key_vault
# ============================================================

variable "project_name" {
  description = "Short project name used in resource naming."
  type        = string
}

variable "environment" {
  description = "Deployment environment: dev, qa or prod."
  type        = string
}

variable "resource_group_name" {
  description = "Name of the Resource Group where Key Vault will be created."
  type        = string
}

variable "location" {
  description = "Azure region where resources will be deployed."
  type        = string
}

variable "tags" {
  description = "Standard tags applied to all resources."
  type        = map(string)
  default     = {}
}

variable "adf_principal_id" {
  description = "Principal ID of the ADF Managed Identity."
  type        = string
}