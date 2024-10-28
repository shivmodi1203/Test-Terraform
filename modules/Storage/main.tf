resource "null_resource" "certs" {
  provisioner "local-exec" {
    command     = "./${path.module}/script.sh Dev Propel"
    interpreter = ["bash", "-c"]
  }
}

resource "azurerm_storage_account" "storage" {
  name                              = "${var.env}${var.prefix}storage"
  resource_group_name               = var.resource_group_name
  location                          = var.location
  account_kind                      = "StorageV2"
  access_tier                       = "Hot"
  account_tier                      = "Standard"
  account_replication_type          = "LRS"
  allow_nested_items_to_be_public   = false
  infrastructure_encryption_enabled = true
  public_network_access_enabled     = true

  tags = var.tags
  depends_on = [ null_resource.certs ]
}

resource "azurerm_storage_container" "container" {
  name                  = "${var.env}-${var.prefix}-certificates"
  storage_account_name  = azurerm_storage_account.storage.name
  container_access_type = "private"
  depends_on = [ azurerm_storage_account.storage ]
}



resource "azurerm_storage_blob" "RootCACertificate" {
  name                   = "DevPropel_RootCACertificate"
  storage_account_name   = azurerm_storage_account.storage.name
  storage_container_name = azurerm_storage_container.container.name
  type                   = "Block"
  source                 = "${path.module}/certs/DevPropel_RootCACertificate.pem"
  content_type           = "text/html"
  depends_on = [ azurerm_storage_container.container ]
}
resource "azurerm_storage_blob" "PrimaryRootCACertificate" {
  name                   = "DevPropel_PrimaryRootCACertificate.pfx"
  storage_account_name   = azurerm_storage_account.storage.name
  storage_container_name = azurerm_storage_container.container.name
  type                   = "Block"
  source                 = "${path.module}/certs/DevPropel_PrimaryRootCACertificate.pem"
  content_type           = "text/html"
  depends_on = [ azurerm_storage_container.container ]
}
resource "azurerm_storage_blob" "SecondaryRootCACertificate" {
  name                   = "DevPropel_SecondaryRootCACertificate"
  storage_account_name   = azurerm_storage_account.storage.name
  storage_container_name = azurerm_storage_container.container.name
  type                   = "Block"
  source                 = "${path.module}/certs/DevPropel_SecondaryRootCACertificate.pem"
  content_type           = "text/html"
  depends_on = [ azurerm_storage_container.container ]
}