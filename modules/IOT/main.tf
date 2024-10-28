resource "azurerm_iothub_dps" "dps" {
  name                = "${var.env}-${var.prefix}-my-dps"
  resource_group_name = var.resource_group_name
  location            = var.location
  allocation_policy   = "Hashed"
  tags                = var.tags
  sku {
    name     = "S1"
    capacity = "1"
  }
}

resource "azurerm_iothub_dps_certificate" "dps-cert" {
 name                = "propelcert"
 resource_group_name = var.resource_group_name
 iot_dps_name        = azurerm_iothub_dps.dps.name
 certificate_content = filebase64(var.rootCA)
}