
resource "azurerm_container_registry" "acr" {
  name                = "rukevwoacr${random_string.suffix.result}"
  resource_group_name = data.azurerm_resource_group.example.name
  location            = data.azurerm_resource_group.example.location

  sku           = "Basic"
  admin_enabled = false

  tags = {
    Environment = "Lab"
    ManagedBy   = "Terraform"
  }

}
