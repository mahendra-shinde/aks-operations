
variable "location" {
	description = "Azure region for the AKS deployment."
	type        = string
	default     = "eastus"
}

variable "resource_group_name" {
	description = "Name of the resource group for AKS."
	type        = string
	default     = "rg-aks-demo"
}

variable "aks_cluster_name" {
	description = "Name of the AKS cluster."
	type        = string
	default     = "aks-demo-cluster"
}

variable "dns_prefix" {
	description = "DNS prefix for the AKS cluster."
	type        = string
	default     = "aksdemocluster"
}
