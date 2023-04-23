# resource "azurerm_windows_virtual_machine" "vm" {
#   name                  = "${local.vmname}-${var.ambiente}"
#   resource_group_name   = data.azurerm_resource_group.sh.name
#   location              = data.azurerm_resource_group.sh.location
#   size                  = "Standard_D2s_v5"
#   network_interface_ids = [azurerm_network_interface.vm_nic.id]
#   provision_vm_agent    = true
#   admin_username        = "gilderson"
#   admin_password        = "Niver@2712"
#   timezone              = "E. South America Standard Time"
#   license_type          = "Windows_Client" # CRITICAL - DO NOT CHANGE OR AZURE WILL CHARGE FOR HOST LICENSES!
#   computer_name         = local.vmname
#   tags = local.tags



#   os_disk {
#     name                 = "${local.vmname}-${var.ambiente}"
#     caching              = "ReadWrite"
#     storage_account_type = "StandardSSD_LRS"
#   }

#   boot_diagnostics {}


#     //source_image_id = "/subscriptions/90228471-f4c3-4267-9cab-92499a9107af/resourceGroups/rg-avd-resources-test/providers/Microsoft.Compute/galleries/galery/images/avd-image"
#     source_image_reference {
#     publisher = "MicrosoftWindowsDesktop"
#     offer     = "Windows-10"
#     sku       = "win10-22h2-ent-g2" #"win10-22h2-avd-g2"
#     version   = "latest"

#     //lifecycle {
#     // ignore_changes  = [ tags ]
#     }
#   }

#   resource "azurerm_public_ip" "PIPvm" {
#     name = "${var.prefix}-pip"
#     resource_group_name = data.azurerm_resource_group.sh.name
#     location = data.azurerm_resource_group.sh.location
#     allocation_method = "Static"
#     tags = local.tags 
    
#   }


