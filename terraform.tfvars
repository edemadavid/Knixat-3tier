# terraform.tfvars

resource_group_name = "cohort3-edema"
location            = "eastus2"

tags = {
  Owner        = "Edema"
  Date_Created = "2023-05-26"
  Environment  = "Development"
}

virtual_network = {
  "vnet"    = "edema-vnet"
  "address" = "10.0.0.0/16"
}

# sub_net = {
#   "web-snet" = "10.0.0.0/24"
#   "api-snet" = "10.0.1.0/24"
#   "db-snet"  = "10.0.2.0/24"
# }

sub_net = {
  "web-snet" = {
    name           = "web-vm"
    address_prefix = "10.0.0.0/24"
  }
  "api-snet" = {
    name           = "api-vm"
    address_prefix = "10.0.1.0/24"
  }
  "db-snet" = {
    name           = "db-vm"
    address_prefix = "10.0.2.0/24"
  }
}


network_security_group = {
  "web-snet" = "web-nsg"
  "api-snet" = "api-nsg"
  "db-snet"  = "db-nsg"
}

nsg-snet = {
  "web-snet" = "web-nsg"
  "api-snet" = "api-nsg"
  "db-snet"  = "db-nsg"
}

network_interface = {
  "vm-nic1" = {
    name                  = "web-nic"
    network_interface_ids = []
  }
  "vm-nic2" = {
    name                  = "api-nic"
    network_interface_ids = []
  }
  "vm-nic3" = {
    name                  = "db-nic"
    network_interface_ids = []
  }
}

ip_config = "internal"

azure_vm = {
  "vm1" = {
    name     = "web-vm"
    size     = "Standard_B1s"
    username = "edemadavid"
    password = "Qwerty12345"
    os_disk  = "myosdisk1"
  }
  "vm2" = {
    name     = "api-vm"
    size     = "Standard_B1s"
    username = "edemadavidr"
    password = "Qwerty12345"
    os_disk  = "myosdisk2"
  }
  "vm3" = {
    name     = "db-vm"
    size     = "Standard_B1s"
    username = "edemadavid"
    password = "Qwerty12345"
    os_disk  = "myosdisk3"
  }
}
