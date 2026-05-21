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