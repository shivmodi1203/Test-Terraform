# module "NullResource" {
#   source = "./modules/NULLResource"
# }

module "StorageAccount" {
  source              = "./modules/Storage"
  env                 = var.env
  prefix              = var.prefix
  resource_group_name = var.resource_group_name
  location            = var.location
  tags                = var.tags
}