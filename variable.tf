variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
  default     = "cohort3-edema"
}

variable "location" {
  description = "Location of the resource group"
  type        = string
  default     = "eastus2"  
}

variable "tags" {
  description = "Tags for the resource group"
  type        = map(string)
  default     = {
    Owner         = "Edema"
    Date_Created  = "2023-05-26"
    Environment   = "Development"
  }
}


variable "vnet_name" {
  description = "Name of the virtual network"
  type        = string
  default     = "edema-vnet"
}

variable "subnet_web_name" {
  description = "Name of the web subnet"
  type        = string
  default     = "web-subnet"
}

variable "subnet_api_name" {
  description = "Name of the API subnet"
  type        = string
  default     = "api-subnet"
}

variable "subnet_db_name" {
  description = "Name of the database subnet"
  type        = string
  default     = "database-subnet"
}

variable "vm_web_name" {
  description = "Name of the web VM"
  type        = string
  default     = "web-vm"
}

variable "vm_api_name" {
  description = "Name of the API VM"
  type        = string
  default     = "api-vm"
}

variable "vm_db_name" {
  description = "Name of the database VM"
  type        = string
  default     = "db-vm"
}

variable "public_ip_name" {
  description = "Name of the public IP"
  type        = string
  default     = "web-server-pip"
}

variable "nsg_web_name" {
  description = "Name of the web subnet NSG"
  type        = string
  default     = "web-subnet-nsg"
}

variable "nsg_api_name" {
  description = "Name of the API subnet NSG"
  type        = string
  default     = "api-subnet-nsg"
}

variable "nsg_db_name" {
  description = "Name of the database subnet NSG"
  type        = string
  default     = "database-subnet-nsg"
}

variable "web_nsg_rules" {
  description = "List of web subnet NSG rules"
  type        = list(object({
    name                       = string
    priority                   = number
    direction                  = string
    access                     = string
    protocol                   = string
    source_port_range          = string
    destination_port_range     = string
    source_address_prefix      = string
    destination_address_prefix = string
  }))
  default = [
    {
      name                       = "Allow_HTTP"
      priority                   = 100
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = "80"
      source_address_prefix      = "*"
      destination_address_prefix = "*"
    },
    {
      name                       = "Allow_HTTPS"
      priority                   = 101
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = "443"
      source_address_prefix      = "*"
      destination_address_prefix = "*"
    },
  ]
}

variable "api_nsg_rules" {
  description = "List of API subnet NSG rules"
  type        = list(object({
    name                       = string
    priority                   = number
    direction                  = string
    access                     = string
    protocol                   = string
    source_port_range          = string
    destination_port_range     = string
    source_address_prefix      = string
    destination_address_prefix = string
  }))
  default = [
    {
      name                       = "Allow_HTTP"
      priority                   = 100
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = "80"
      source_address_prefix      = "*"
      destination_address_prefix = "*"
    },
    {
      name                       = "Allow_HTTPS"
      priority                   = 101
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = "443"
      source_address_prefix      = "*"
      destination_address_prefix = "*"
    },
  ]
}

variable "db_nsg_rules" {
  description = "List of database subnet NSG rules"
  type        = list(object({
    name                       = string
    priority                   = number
    direction                  = string
    access                     = string
    protocol                   = string
    source_port_range          = string
    destination_port_range     = string
    source_address_prefix      = string
    destination_address_prefix = string
  }))
  default = [
    {
      name                       = "Allow_SQL"
      priority                   = 100
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = "1433"
      source_address_prefix      = "*"
      destination_address_prefix = "*"
    },
  ]
}
