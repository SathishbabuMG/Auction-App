provider "azurerm" {
  features {}

  client_id       = var.client_id
  client_secret   = var.client_secret
  subscription_id = var.subscription_id
  tenant_id       = var.tenant_id
}

resource "azurerm_resource_group" "ansible_rg" {
  name     = var.resource_group_name
  location = var.location
}

resource "azurerm_virtual_network" "ansible_vnet" {
  name                = "ansible-vnet"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.ansible_rg.location
  resource_group_name = azurerm_resource_group.ansible_rg.name
}

resource "azurerm_subnet" "ansible_subnet" {
  name                 = "ansible-subnet"
  resource_group_name  = azurerm_resource_group.ansible_rg.name
  virtual_network_name = azurerm_virtual_network.ansible_vnet.name
  address_prefixes     = ["10.0.2.0/24"]
}

resource "azurerm_public_ip" "ansible_public_ip" {
  name                = "ansible-public-ip"
  location            = azurerm_resource_group.ansible_rg.location
  resource_group_name = azurerm_resource_group.ansible_rg.name
  allocation_method   = "Static"
  sku                 = "Basic"
}

resource "azurerm_network_interface" "ansible_nic" {
  name                = "ansible-nic"
  location            = azurerm_resource_group.ansible_rg.location
  resource_group_name = azurerm_resource_group.ansible_rg.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.ansible_subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.ansible_public_ip.id
  }
}

resource "azurerm_network_security_group" "ansible_nsg" {
  name                = "ansible-nsg"
  location            = azurerm_resource_group.ansible_rg.location
  resource_group_name = azurerm_resource_group.ansible_rg.name

  security_rule {
    name                       = "SSH"
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

resource "azurerm_network_interface_security_group_association" "ansible_nic_nsg" {
  network_interface_id      = azurerm_network_interface.ansible_nic.id
  network_security_group_id = azurerm_network_security_group.ansible_nsg.id
}

resource "azurerm_linux_virtual_machine" "ansible_vm" {
  name                = var.vm_name
  resource_group_name = azurerm_resource_group.ansible_rg.name
  location            = azurerm_resource_group.ansible_rg.location
  size                = var.vm_size
  admin_username      = var.admin_username
  network_interface_ids = [
    azurerm_network_interface.ansible_nic.id,
  ]

  admin_ssh_key {
    username   = var.admin_username
    public_key = file(var.ssh_public_key_path)
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }

  tags = {
    environment = "ansible"
  }
}
