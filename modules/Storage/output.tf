output "rootCA" {
  value = azurerm_storage_blob.RootCACertificate.source
}