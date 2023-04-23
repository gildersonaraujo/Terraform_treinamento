data "azurerm_storage_account" "storage" {
  name                = "stoavdtst01"
  resource_group_name = data.azurerm_resource_group.sh.name
}


//----------------------//---------------------------------//-------------//

#Permissionamento Storage

resource "azurerm_storage_share" "FsLogix" {
  name = "fslogix"
  storage_account_name = data.azurerm_storage_account.storage.name
  depends_on = [data.azurerm_storage_account.storage ]
  quota = 100
  enabled_protocol = "SMB"
  
}