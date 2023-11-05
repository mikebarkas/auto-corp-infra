variable "container_image" {
  type = string
}

provider "azurerm" {
  features {}
  skip_provider_registration = true
}

resource "azurerm_resource_group" "auto-corp-rg" {
  name     = "auto-corp-rg"
  location = "eastus"
}

resource "azurerm_container_group" "auto-corp-cg" {
  name                = "auto-corp-cg"
  location            = azurerm_resource_group.auto-corp-rg.location
  resource_group_name = azurerm_resource_group.auto-corp-rg.name
  ip_address_type     = "Public"
  dns_name_label      = "auto-corp-dns"
  os_type             = "Linux"

  container {
    name   = "auto-corp-web"
    image  = var.container_image
    cpu    = "0.5"
    memory = "1.5"

    ports {
      port     = 8081
      protocol = "TCP"
    }
  }

}
