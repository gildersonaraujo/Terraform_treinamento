locals {
  registration_token = azurerm_virtual_desktop_host_pool_registration_info.registrationinfo.token
}

# resource "azurerm_virtual_desktop_host_pool_registration_info" "registration_token" {
#   hostpool_id     = azurerm_virtual_desktop_host_pool.hostpool.id
#   expiration_date = "2024-01-01T23:40:52Z"
# }

resource "azurerm_windows_virtual_machine" "avd_vm" {
  #count                 = var.rdsh_count
  name                  = "${var.prefix}-vmavd"
  resource_group_name   = data.azurerm_resource_group.sh.name
  location              = data.azurerm_resource_group.sh.location
  size                  = var.vm_size
  network_interface_ids = [azurerm_network_interface.vm_nic.id]
  provision_vm_agent    = true
  admin_username        = "gilderson"
  admin_password        = "Niver@2712"
  source_image_id = data.azurerm_shared_image_version.version000.id

  os_disk {
    name                 = "${lower(var.prefix)}-disk"
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }
  
  
 
  
}

resource "azurerm_virtual_machine_extension" "domain_join" {
  #count                      = var.rdsh_count
  name                       = "${var.prefix}-domainJoin"
  virtual_machine_id         = azurerm_windows_virtual_machine.avd_vm.id
  publisher                  = "Microsoft.Compute"
  type                       = "JsonADDomainExtension"
  type_handler_version       = "1.3"
  auto_upgrade_minor_version = true

  settings = <<SETTINGS
    {
      "Name": "${var.domain_name}",
      "OUPath": "${var.ou_path}",
      "User": "${var.domain_user_upn}@${var.domain_name}",
      "Restart": "true",
      "Options": "3"
    }
SETTINGS

  protected_settings = <<PROTECTED_SETTINGS
    {
      "Password": "${var.domain_password}"
    }
PROTECTED_SETTINGS

  lifecycle {
    ignore_changes = [settings, protected_settings]
  }
}

resource "azurerm_virtual_machine_extension" "vmext_dsc" {
  #count                      = var.rdsh_count
  name                       = "${var.prefix}-avd_dsc"
  virtual_machine_id         = azurerm_windows_virtual_machine.avd_vm.id
  publisher                  = "Microsoft.Powershell"
  type                       = "DSC"
  type_handler_version       = "2.73"
  auto_upgrade_minor_version = true

  settings = <<-SETTINGS
    {
      "modulesUrl": "https://wvdportalstorageblob.blob.core.windows.net/galleryartifacts/Configuration_09-08-2022.zip",
      "configurationFunction": "Configuration.ps1\\AddSessionHost",
      "properties": {
        "HostPoolName":"${azurerm_virtual_desktop_host_pool.hostpool.name}"
      }
    }
SETTINGS

  protected_settings = <<PROTECTED_SETTINGS
  {
    "properties": {
      "registrationInfoToken": "${local.registration_token}"
    }
  }
 PROTECTED_SETTINGS

#   depends_on = [
#     azurerm_virtual_machine_extension.domain_join,
#     azurerm_virtual_desktop_host_pool.hostpool
#   ]
}

resource "azurerm_virtual_desktop_host_pool_registration_info" "registrationinfo" {
  hostpool_id = azurerm_virtual_desktop_host_pool.hostpool.id
  expiration_date = "2023-05-22T23:40:52Z"
  
}