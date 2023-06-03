# Create a resource group
resource "azurerm_resource_group" "rg" {
  name     = var.resource_group_name
  location = var.location
  tags     = var.tags
}

# Create a virtual network within the resource group
resource "azurerm_virtual_network" "vnet" {
  name                = var.virtual_network.vnet
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  address_space       = [var.virtual_network.address]
}

# Creation of 3 subnets
resource "azurerm_network_security_group" "nsg" {
  for_each            = var.sub_net
  name                = each.key
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
}

resource "azurerm_subnet" "snet" {
  for_each             = var.sub_net
  name                 = each.key
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = var.virtual_network["vnet"]
  address_prefixes     = [each.value.address_prefix]
}

resource "azurerm_subnet_network_security_group_association" "nsg-snet" {
  for_each                    = var.sub_net
  subnet_id                   = azurerm_subnet.snet[each.key].id
  network_security_group_id   = azurerm_network_security_group.nsg[each.key].id
}

resource "azurerm_network_interface" "nic" {
  for_each            = var.vm_instances
  name                = each.key
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "config-${each.key}"
    subnet_id                     = azurerm_subnet.snet[each.value.subnet].id
    private_ip_address_allocation = "Dynamic"
  }
}

#NSG Rules
resource "azurerm_network_security_rule" "web-nsg-rule" {
  for_each                    = local.web-nsg-rules
  name                        = each.value.name
  priority                    = each.value.priority
  direction                   = each.value.direction
  access                      = each.value.access
  protocol                    = each.value.protocol
  source_port_range           = each.value.source_port_range
  destination_port_range      = each.value.destination_port_range
  source_address_prefix       = each.value.source_address_prefix
  destination_address_prefix  = each.value.destination_address_prefix
  resource_group_name         = azurerm_resource_group.rg.name
  network_security_group_name = var.network_security_group.web-snet
}

resource "azurerm_network_security_rule" "api-nsg-rule" {
  for_each                    = local.api-nsg-rules
  name                        = each.value.name
  priority                    = each.value.priority
  direction                   = each.value.direction
  access                      = each.value.access
  protocol                    = each.value.protocol
  source_port_range           = each.value.source_port_range
  destination_port_range      = each.value.destination_port_range
  source_address_prefix       = each.value.source_address_prefix
  destination_address_prefix  = each.value.destination_address_prefix
  resource_group_name         = azurerm_resource_group.rg.name
  network_security_group_name = var.network_security_group.api-snet
}

resource "azurerm_network_security_rule" "db-nsg-rule" {
  for_each                    = local.db-nsg-rules
  name                        = each.value.name
  priority                    = each.value.priority
  direction                   = each.value.direction
  access                      = each.value.access
  protocol                    = each.value.protocol
  source_port_range           = each.value.source_port_range
  destination_port_range      = each.value.destination_port_range
  source_address_prefix       = each.value.source_address_prefix
  destination_address_prefix  = each.value.destination_address_prefix
  resource_group_name         = azurerm_resource_group.rg.name
  network_security_group_name = var.network_security_group.db-snet
}

#Create 3 VMs
resource "azurerm_virtual_machine" "main" {
  for_each              = var.azure_vm
  name                  = each.value.name
  location              = azurerm_resource_group.rg.location
  resource_group_name   = azurerm_resource_group.rg.name
  network_interface_ids = [azurerm_network_interface.nic[each.key].id]
  vm_size               = each.value.size

  delete_os_disk_on_termination = true

  storage_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts-gen2"
    version   = "latest"
  }
  storage_os_disk {
    name              = each.value.os_disk
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }
  os_profile {
    computer_name  = each.value.name
    admin_username = each.value.username
    admin_password = each.value.password
  }
  os_profile_linux_config {
    disable_password_authentication = false
  }
  tags = {
    Environment = var.tags.Environment
  }
}
