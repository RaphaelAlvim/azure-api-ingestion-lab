# ============================================================
# Variables — module: azure_sql
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
  description = "Name of the Resource Group where SQL will be created."
  type        = string
}

variable "location" {
  description = "Azure region where resources will be deployed."
  type        = string
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

variable "tags" {
  description = "Standard tags applied to all resources."
  type        = map(string)
  default     = {}
}