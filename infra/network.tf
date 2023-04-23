resource "azurerm_virtual_network" "vnet" {
  name                = "${var.prefix}-VNet-${lower(var.ambiente)}"
  address_space       = var.vnet_range
  dns_servers         = var.dns_servers
  location            = var.deploy_location
  resource_group_name = data.azurerm_resource_group.sh.name
  tags                = local.tags
  //depends_on          = [azurerm_resource_group.sh]
 
}

resource "azurerm_subnet" "subnet" {
  name                 = "${var.sub_desktop}-${lower(var.ambiente)}"
  resource_group_name  = data.azurerm_resource_group.sh.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = var.subnet_range
  //depends_on           = [azurerm_resource_group.rg]
}


resource "azurerm_network_interface" "vm_nic" {
  name                = "nic-${var.prefix}-${var.ambiente}"
  resource_group_name = data.azurerm_resource_group.sh.name
  location            = data.azurerm_resource_group.sh.location
  //enable_accelerated_networking = true

  ip_configuration {
    name                          = "nic-us-${var.prefix}-config-${var.ambiente}"
    subnet_id                     = azurerm_subnet.subnet.id
    private_ip_address_allocation = "Dynamic"
    # public_ip_address_id = azurerm_public_ip.PIPvm.id

    
  }

  lifecycle {
    ignore_changes = [tags]
  }

}

resource "azurerm_network_security_group" "nsg" {
  name                = "${var.prefix}-NSG-${lower(var.ambiente)}"
  location            = var.deploy_location
  resource_group_name = data.azurerm_resource_group.sh.name
  security_rule {
    name                       = "HTTPS"
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "443"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
  security_rule {
    name                       = "RDP"
    priority                   = 300
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "3389"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
  //depends_on = [azurerm_resource_group.rg]
}

resource "azurerm_subnet_network_security_group_association" "nsg_assoc" {
  subnet_id                 = azurerm_subnet.subnet.id
  network_security_group_id = azurerm_network_security_group.nsg.id
}

data "azurerm_virtual_network" "souce_vnet" {
  name = "Ad-local-vnet"
  resource_group_name = data.azurerm_resource_group.sh.name
  
}

resource "azurerm_virtual_network_peering" "peering-Datasouce-terraform" {
  name = "peering-Datasouce-terraform"
  resource_group_name = data.azurerm_resource_group.sh.name
  virtual_network_name = data.azurerm_virtual_network.souce_vnet.name
  remote_virtual_network_id = azurerm_virtual_network.vnet.id
  
}

resource "azurerm_virtual_network_peering" "peering-terraform-Datasouce" {
  name = "peering-terraform-Datasouce"
  resource_group_name = data.azurerm_resource_group.sh.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  remote_virtual_network_id = data.azurerm_virtual_network.souce_vnet.id
  
}