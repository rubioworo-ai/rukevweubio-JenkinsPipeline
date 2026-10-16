

variable "location" {
  description = "Azure region approved for this deployment"
  type        = string
  default     = "eastus"
}

variable "resource_group_name" {
  type        = string
  description = "The name of the resource group"

}

variable "default_node_pool" {
  type        = string
  description = "Name of the default node pool"
  default     = "systempool"
}

variable "cluster_name" {
  type        = string
  description = "The name of the Managed Kubernetes Cluster."
  default     = "example-aks1"
}