locals {
  web-nsg-rules = {
    http = {
      name                       = "AllowAnyHTTPInboundtoWebServer"
      priority                   = 100
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = 80
      source_address_prefix      = "*"
      destination_address_prefix = "10.0.0.0/24"
    }
    ssh = {
      name                       = "AllowAnySSHInboundtoWebServer"
      priority                   = 120
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = 22
      source_address_prefix      = "*"
      destination_address_prefix = "10.0.0.0/24"
    }
  }

  api-nsg-rules = {
    http1 = {
      name                       = "DenyAnyHTTPInboundtoAPIServer"
      priority                   = 100
      direction                  = "Inbound"
      access                     = "Deny"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = 80
      source_address_prefix      = "*"
      destination_address_prefix = "10.0.1.0/24"
    }
    http2 = {
      name                       = "AllowWebServerHTTPInboundtoAPIServer"
      priority                   = 120
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = 80
      destination_port_range     = 80
      source_address_prefix      = "10.0.0.0/24"
      destination_address_prefix = "10.0.0.0/24"
    }
    ssh = {
      name                       = "AllowWebServerSSHInboundtoAPIServer"
      priority                   = 140
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = 22
      source_address_prefix      = "10.0.0.0/24"
      destination_address_prefix = "10.0.1.0/24"
    }
    http3 = {
      name                       = "AllowAPIHTTPOutboundtoWebServer"
      priority                   = 160
      direction                  = "Outbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = 80
      destination_port_range     = 80
      source_address_prefix      = "10.0.1.0/24"
      destination_address_prefix = "10.0.0.0/24"
    }
  }

  db-nsg-rules = {
    http1 = {
      name                       = "DenyAnyHTTPInboundtoDBServer"
      priority                   = 100
      direction                  = "Inbound"
      access                     = "Deny"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = 80
      source_address_prefix      = "*"
      destination_address_prefix = "10.0.2.0/24"
    }
    http2 = {
      name                       = "AllowAPIServerHTTPInboundtoDBServer"
      priority                   = 120
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = 80
      destination_port_range     = 80
      source_address_prefix      = "10.0.1.0/24"
      destination_address_prefix = "10.0.2.0/24"
    }
    ssh = {
      name                       = "AllowAPIServerSSHInboundtoDBServer"
      priority                   = 140
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = 22
      source_address_prefix      = "10.0.1.0/24"
      destination_address_prefix = "10.0.2.0/24"
    }
    http3 = {
      name                       = "AllowDBHTTPOutboundtoAPIServer"
      priority                   = 160
      direction                  = "Outbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = 80
      destination_port_range     = 80
      source_address_prefix      = "10.0.2.0/24"
      destination_address_prefix = "10.0.1.0/24"
    }
    http4 = {
      name                       = "DenyDBHTTPOutboundtoWebServer"
      priority                   = 180
      direction                  = "Outbound"
      access                     = "Deny"
      protocol                   = "Tcp"
      source_port_range          = 80
      destination_port_range     = 80
      source_address_prefix      = "10.0.2.0/24"
      destination_address_prefix = "10.0.0.0/24"
    }
  }
}