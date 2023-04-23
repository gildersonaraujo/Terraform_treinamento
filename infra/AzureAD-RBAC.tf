#  data "azuread_user" "aad_user" {
#   for_each            = toset(var.avd_users)
#   user_principal_name = format("%s", each.key)
# }

# resource "azuread_group_member" "aad_group_member" {
#   for_each         = data.azuread_user.aad_user
#   group_object_id  = azuread_group.aad_group.id
#   member_object_id = each.value["id"]
# }


#Grupos que foram sincronizados para o Azure
data "azuread_group" "aad_group" { //Grupo com A DAG
display_name     = "Users_AVD"
}
data "azuread_group" "aad_group_contributor" { //Grupo com acesso ao AVD
display_name     = "Contributor_AVD"
}
data "azuread_group" "aad_group_elevated" { //Grupo com acesso elevado para administrar ao AVD
display_name     = "Admins_AVD"
}
data "azuread_group" "aad_group_read" { //Grupo com acessoapenas leitura
display_name     = "Read_AVD"
}

#Role definition existente no Azure (RBACK)

data "azurerm_role_definition" "role_AVD" { # access an existing built-in role
  name = "Desktop Virtualization User"
}
data "azurerm_role_definition" "role-SMB-Contibutor" { # access an existing built-in role
  name = "Storage File Data SMB Share Contributor"
}
data "azurerm_role_definition" "role-SMB-Elevated-Contibutor" { # access an existing built-in role
  name = "Storage File Data SMB Share Elevated Contributor"
}
data "azurerm_role_definition" "role-SMB-Read" { # access an existing built-in role
  name = "Storage File Data SMB Share Reader"
}

#Atribuindo as permissoões aos grupos

resource "azurerm_role_assignment" "role_DAG" {
  scope              = azurerm_virtual_desktop_application_group.dag.id
  role_definition_id = data.azurerm_role_definition.role_AVD.id
  principal_id       = data.azuread_group.aad_group.id // Object ID do Grupo 
}
resource "azurerm_role_assignment" "role_SMB_Contributor" {
  scope              = data.azurerm_storage_account.storage.id
  role_definition_id = data.azurerm_role_definition.role-SMB-Contibutor.id
  principal_id       = data.azuread_group.aad_group_contributor.id // Object ID do Grupo 
}
resource "azurerm_role_assignment" "role_SMB_Elevated" {
  scope              = data.azurerm_storage_account.storage.id
  role_definition_id = data.azurerm_role_definition.role-SMB-Elevated-Contibutor.id
  principal_id       = data.azuread_group.aad_group_elevated.id // Object ID do Grupo 
}
resource "azurerm_role_assignment" "role_SMB_Read" {
  scope              = data.azurerm_storage_account.storage.id
  role_definition_id = data.azurerm_role_definition.role-SMB-Read.id
  principal_id       = data.azuread_group.aad_group_read.id // Object ID do Grupo 
}


