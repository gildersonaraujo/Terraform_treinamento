locals {
  vmname = "avdimg001"
  tagset = {
    "Application" = "AVD Management Resources"
    "Area"        = "GOP"
    "CostOwner"   = "11171213"
    "Environment" = "Production"
    "Owner"       = "FRANCS64"
  }
}

resource "random_password" "vm_local_password" {
  length           = 16
  special          = true
  lower            = true
  upper            = true
  numeric          = true
  override_special = "*()#$-?![]"
}


# Creates Shared Image Gallery
# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/shared_image_gallery
data "azurerm_shared_image_gallery" "sig" {
  name                = "galery"
  resource_group_name = data.azurerm_resource_group.sh.name
}

//Creates image definition
//https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/shared_image
 data "azurerm_shared_image" "example" {
  name                = "WINDOWS10-VM_IMAGE"
  gallery_name =  data.azurerm_shared_image_gallery.sig.name
  resource_group_name = data.azurerm_resource_group.sh.name
}

 data "azurerm_shared_image_version" "version000" {
 name = "0.0.0"
 image_name = data.azurerm_shared_image.example.name
 gallery_name = data.azurerm_shared_image_gallery.sig.name
 resource_group_name = data.azurerm_resource_group.sh.name
 }
  
# }

# resource "azurerm_management_lock" "galery" {
#   name       = "${var.prefix}-lock"
#   scope      = azurerm_shared_image.example.id
#   lock_level = "CanNotDelete"
#   notes      = "Locked because it's needed by a third-party"
# }

# resource "azurerm_management_lock" "share-galery" {
#   name       = "${var.prefix}-lock"
#   scope      = azurerm_shared_image_gallery.sig.id
#   lock_level = "CanNotDelete"
#   notes      = "Locked because it's needed by a third-party"
# }
