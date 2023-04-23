
# Resource group name is output when execution plan is applied.
data "azurerm_resource_group" "sh" {
  name = "Az140-resouce-group-hub"

}

# Create AVD host pool
resource "azurerm_virtual_desktop_host_pool" "hostpool" {
  resource_group_name      = data.azurerm_resource_group.sh.name
  location                 = data.azurerm_resource_group.sh.location
  name                     = "${var.hostpool}-${lower(var.ambiente)}"
  friendly_name            = var.hostpool
  validate_environment     = true
  custom_rdp_properties    = "audiocapturemode:i:1;audiomode:i:0;"
  description              = "${var.prefix}- Terraform HostPool"
  type                     = "Pooled"
  maximum_sessions_allowed = 5
  load_balancer_type       = "BreadthFirst"
  tags                     = local.tags
}
# Create AVD workspace
resource "azurerm_virtual_desktop_workspace" "workspace" {
  name                = "${var.workspace}-${lower(var.ambiente)}"
  resource_group_name = data.azurerm_resource_group.sh.name
  location            = data.azurerm_resource_group.sh.location
  friendly_name       = "${var.workspace}-${lower(var.ambiente)}"
  description         = "${var.workspace}-${lower(var.ambiente)}"
  tags                = local.tags
}

# Create AVD DAG
resource "azurerm_virtual_desktop_application_group" "dag" {
  resource_group_name = data.azurerm_resource_group.sh.name
  host_pool_id        = azurerm_virtual_desktop_host_pool.hostpool.id
  location            = data.azurerm_resource_group.sh.location
  type                = "Desktop"
  name                = "${var.prefix}-dag-${lower(var.ambiente)}"
  friendly_name       = "Desktop AppGroup"
  description         = "AVD application group"
  depends_on          = [azurerm_virtual_desktop_host_pool.hostpool, azurerm_virtual_desktop_workspace.workspace]
}

# Associate Workspace and DAG
resource "azurerm_virtual_desktop_workspace_application_group_association" "ws-dag" {
  application_group_id = azurerm_virtual_desktop_application_group.dag.id
  workspace_id         = azurerm_virtual_desktop_workspace.workspace.id
}