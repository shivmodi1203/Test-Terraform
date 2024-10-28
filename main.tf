module "StorageAccount" {
  source              = "./modules/Storage"
  env                 = var.env
  prefix              = var.prefix
  resource_group_name = var.resource_group_name
  location            = var.location
  tags                = var.tags
}

module "IOT" {
  source = "./modules/IOT"
  env                 = var.env
  prefix              = var.prefix
  resource_group_name = var.resource_group_name
  location            = var.location
  tags                = var.tags
  rootCA              = module.StorageAccount.rootCA
}