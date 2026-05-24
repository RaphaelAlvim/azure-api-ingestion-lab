# ============================================================
# Variables — azure-api-ingestion-lab
# ============================================================

variable "subscription_id" {
  description = "Azure subscription ID where resources will be deployed."
  type        = string
  sensitive   = true
}

variable "project_name" {
  description = "Short project name used in resource naming."
  type        = string
}

variable "environment" {
  description = "Deployment environment: dev, qa or prod."
  type        = string
}

variable "location" {
  description = "Azure region where resources will be deployed."
  type        = string
}

variable "storage_containers" {
  description = "List of lake containers to be created in ADLS Gen2."
  type        = list(string)
  default     = ["raw", "bronze", "silver", "gold"]
}

variable "tags" {
  description = "Standard tags applied to all resources."
  type        = map(string)
  default     = {}
}

variable "sql_admin_login" {
  description = "Administrator login for the SQL Server."
  type        = string
}

variable "sql_admin_password" {
  description = "Administrator password for the SQL Server."
  type        = string
  sensitive   = true
}

variable "github_account_name" {
  description = "GitHub account name for ADF Git Integration."
  type        = string
}

variable "github_repository_name" {
  description = "GitHub repository name for ADF Git Integration."
  type        = string
}