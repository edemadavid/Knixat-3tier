provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "rg" {
  name     = var.resource_group_name
  location = var.location
  tags     = var.tags
}


resource "azurerm_virtual_network" "vnet" {
  name                = var.vnet_name
  address_space       = ["10.0.0.0/16"]  
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
}

resource "azurerm_subnet" "web_subnet" {
  name                 = var.subnet_web_name
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.1.0/24"]  
}

resource "azurerm_subnet" "api_subnet" {
  name                 = var.subnet_api_name
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.2.0/24"]  
}

resource "azurerm_subnet" "db_subnet" {
  name                 = var.subnet_db_name
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.3.0/24"] 
}

resource "azurerm_network_security_group" "web_nsg" {
  name                = var.nsg_web_name
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
}

resource "azurerm_network_security_group" "api_nsg" {
  name                = var.nsg_api_name
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
}

resource "azurerm_network_security_group" "db_nsg" {
  name                = var.nsg_db_name
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
}

resource "azurerm_network_security_rule" "web_nsg_rules" {
  for_each = var.web_nsg_rules

  name                       = each.value.name
  priority                   = each.value.priority
  direction                  = each.value.direction
  access                     = each.value.access
  protocol                   = each.value.protocol
  source_port_range          = each.value.source_port_range
  destination_port_range     = each.value.destination_port_range
  source_address_prefix      = each.value.source_address_prefix
  destination_address_prefix = each.value.destination_address_prefix
  resource_group_name        = azurerm_resource_group.rg.name
  security_group_name        = azurerm_network_security_group.web_nsg.name
}

resource "azurerm_network_security_rule" "api_nsg_rules" {
  for_each = var.api_nsg_rules

  name                       = each.value.name
  priority                   = each.value.priority
  direction                  = each.value.direction
  access                     = each.value.access
  protocol                   = each.value.protocol
  source_port_range          = each.value.source_port_range
  destination_port_range     = each.value.destination_port_range
  source_address_prefix      = each.value.source_address_prefix
  destination_address_prefix = each.value.destination_address_prefix
  resource_group_name        = azurerm_resource_group.rg.name
  security_group_name        = azurerm_network_security_group.api_nsg.name
}

resource "azurerm_network_security_rule" "db_nsg_rules" {
  for_each = var.db_nsg_rules

  name                       = each.value.name
  priority                   = each.value.priority
  direction                  = each.value.direction
  access                     = each.value.access
  protocol                   = each.value.protocol
  source_port_range          = each.value.source_port_range
  destination_port_range     = each.value.destination_port_range
  source_address_prefix      = each.value.source_address_prefix
  destination_address_prefix = each.value.destination_address_prefix
  resource_group_name        = azurerm_resource_group.rg.name
  security_group_name        = azurerm_network_security_group.db_nsg.name
}

resource "azurerm_public_ip" "public_ip" {
  name                = var.public_ip_name
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  allocation_method   = "Static"  
}

resource "azurerm_network_interface" "web_nic" {
  name                      = "web-nic"
  location                  = azurerm_resource_group.rg.location
  resource_group_name       = azurerm_resource_group.rg.name
  network_security_group_id = azurerm_network_security_group.web_nsg.id

  ip_configuration {
    name                          = "web-ipconfig"
    subnet_id                     = azurerm_subnet.web_subnet.id
    private_ip_address_allocation = "Dynamic"  
    public_ip_address_id          = azurerm_public_ip.public_ip.id
  }
}

resource "azurerm_network_interface" "api_nic" {
  name                      = "api-nic"
  location                  = azurerm_resource_group.rg.location
  resource_group_name       = azurerm_resource_group.rg.name
  network_security_group_id = azurerm_network_security_group.api_nsg.id

  ip_configuration {
    name                          = "api-ipconfig"
    subnet_id                     = azurerm_subnet.api_subnet.id
    private_ip_address_allocation = "Dynamic"  
  }
}

resource "azurerm_network_interface" "db_nic" {
  name                      = "db-nic"
  location                  = azurerm_resource_group.rg.location
  resource_group_name       = azurerm_resource_group.rg.name
  network_security_group_id = azurerm_network_security_group.db_nsg.id

  ip_configuration {
    name                          = "db-ipconfig"
    subnet_id                     = azurerm_subnet.db_subnet.id
    private_ip_address_allocation = "Dynamic"  
  }
}

resource "azurerm_linux_virtual_machine" "web_vm" {
  name                  = var.vm_web_name
  location              = azurerm_resource_group.rg.location
  resource_group_name   = azurerm_resource_group.rg.name
  network_interface_ids = [azurerm_network_interface.web_nic.id]
  size                  = "Standard_B1s"  
  admin_username        = "edemadavid" 
  admin_password        = "Qwerty123456" 
  image_publisher       = "Canonical"
  image_offer           = "UbuntuServer"
  image_sku             = "18.04-LTS"
  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }
}

resource "azurerm_linux_virtual_machine" "api_vm" {
  name                  = var.vm_api_name
  location              = azurerm_resource_group.rg.location
  resource_group_name   = azurerm_resource_group.rg.name
  network_interface_ids = [azurerm_network_interface.api_nic.id]
  size                  = "Standard_B1s" 
  admin_username        = "edemadavid" 
  admin_password        = "Qwerty123456"  
  image_publisher       = "Canonical"
  image_offer           = "UbuntuServer"
  image_sku             = "18.04-LTS"
  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }
}

resource "azurerm_linux_virtual_machine" "db_vm" {
  name                  = var.vm_db_name
  location              = azurerm_resource_group.rg.location
  resource_group_name   = azurerm_resource_group.rg.name
  network_interface_ids = [azurerm_network_interface.db_nic.id]
  size                  = "Standard_B1s"  
  admin_username        = "edemadavid"  
  admin_password        = "Qwerty123456"  
  image_publisher       = "Canonical"
  image_offer           = "UbuntuServer"
  image_sku             = "18.04-LTS"
  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }
}
