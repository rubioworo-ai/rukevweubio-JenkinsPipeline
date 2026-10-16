terraform {
  backend "azurerm" {
    resource_group_name  = "kml_rg_main-b7db14d0ce4d49d5"
    storage_account_name = "tfstateacc98765"
    container_name       = "tfstate"
    key                  = "aks-cluster.tfstate"
  }
}