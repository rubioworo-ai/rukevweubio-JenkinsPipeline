terraform {
  backend "azurerm" {
    resource_group_name  = "kml_rg_main-ee7d524881fe436a"
    storage_account_name = "tfstateacc98765"
    container_name       = "tfstate"
    key                  = "aks-cluster.tfstate"
  }
}
