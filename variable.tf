variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
  # default     = "cohort3-edema"
}

variable "location" {
  description = "Location of the resource group"
  type        = string
  # default     = "eastus2"
}

variable "tags" {
  description = "Tags for the resource group"
  type        = map(string)
  # default = {
  #   Owner        = "Edema"
  #   Date_Created = "2023-05-26"
  #   Environment  = "Development"
  # }
}


variable "virtual_network" {
  type = map(string)
  default = {
    "vnet"    = "edema-vnet"
    "address" = "10.0.0.0/16"
  }
}

# variable "sub_net" {
#   type = map(string)
#   default = {
#     "web-snet" = "10.0.0.0/24"
#     "api-snet" = "10.0.1.0/24"
#     "db-snet"  = "10.0.2.0/24"
#   }
# }

variable "sub_net" {
  type = map(object({
    name           = string
    address_prefix = string
  }))
  # default = {
  #   vm1 = {
  #     name           = "web-vm"
  #     address_prefix = "10.0.0.0/24"
  #   }
  #   vm2 = {
  #     name           = "api-vm"
  #     address_prefix = "10.0.1.0/24"
  #   }
  #   vm3 = {
  #     name           = "db-vm"
  #     address_prefix = "10.0.2.0/24"
  #   }
  # }
}


variable "network_security_group" {
  type = map(string)
  # default = {
  #   "web-snet" = "web-nsg"
  #   "api-snet" = "api-nsg"
  #   "db-snet"  = "db-nsg"
  # }
}

variable "nsg-snet" {
  type = map(string)
  # default = {
  #   "web-snet" = "web-nsg"
  #   "api-snet" = "api-nsg"
  #   "db-snet"  = "db-nsg"
  # }
}

variable "network_interface" {
  type = map(object({
    name                  = string
    network_interface_ids = list(string)
  }))
  # default = {
  #   "vm-nic1" = {
  #     name                  = "web-nic"
  #     network_interface_ids = []
  #   }
  #   "vm-nic2" = {
  #     name                  = "api-nic"
  #     network_interface_ids = []
  #   }
  #   "vm-nic3" = {
  #     name                  = "db-nic"
  #     network_interface_ids = []
  #   }
  # }
  description = "Network interface details"
}

variable "ip_config" {
  type        = string
  # default     = "internal"
  description = "IP Configuration"
}

variable "azure_vm" {
  type = map(object({
    name     = string
    size     = string
    username = string
    password = string
    os_disk  = string
  }))

  # default = {
  #   "vm1" = {
  #     name     = "web-vm"
  #     size     = "Standard_B1s"
  #     username = "edemadavid"
  #     password = "Qwerty12345"
  #     os_disk  = "myosdisk1"
  #   }
  #   "vm2" = {
  #     name     = "api-vm"
  #     size     = "Standard_B1s"
  #     username = "edemadavidr"
  #     password = "Qwerty12345"
  #     os_disk  = "myosdisk2"
  #   }
  #   "vm3" = {
  #     name     = "db-vm"
  #     size     = "Standard_B1s"
  #     username = "edemadavid"
  #     password = "Qwerty12345"
  #     os_disk  = "myosdisk3"
  #   }
  # }

  description = "VM details"
}

variable "vm_instances" {
  type = map(object({
    subnet = string
  }))
  # default = {
  #   vm1 = {
  #     subnet = "web-snet"
  #   }
  #   vm2 = {
  #     subnet = "api-snet"
  #   }
  #   vm3 = {
  #     subnet = "db-snet"
  #   }
  # }
}
