# ============================================================
# Variables — module: adls
# ============================================================

variable "project_name" {
  description = "Short project name used in resource naming."
  type        = string
}

variable "environment" {
  description = "Deployment environment: dev, qa or prod."
  type        = string
}

variable "suffix" {
  description = "Random suffix to ensure storage account name is globally unique."
  type        = string
}

variable "resource_group_name" {
  description = "Name of the Resource Group where ADLS will be created."
  type        = string
}

variable "location" {
  description = "Azure region where resources will be deployed."
  type        = string
}

variable "containers" {
  description = "List of containers to create in ADLS Gen2."
  type        = list(string)
  default     = ["raw", "bronze", "silver", "gold"]
}

variable "tags" {
  description = "Standard tags applied to all resources."
  type        = map(string)
  default     = {}
}