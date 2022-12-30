resource "azurerm_resource_group" "this" {
  name     = var.resource_group_name
  location = var.location
}

resource "azurerm_virtual_network" "this" {
  name                = var.vnet.name
  address_space       = var.vnet.address_space
  location            = azurerm_resource_group.this.location
  resource_group_name = azurerm_resource_group.this.name
}

resource "azurerm_subnet" "this" {
  name                 = var.vnet.subnet.name
  resource_group_name  = azurerm_resource_group.this.name
  virtual_network_name = azurerm_virtual_network.this.name
  address_prefixes     = var.vnet.subnet.address_prefixes
}

module "vm" {
  source = "../"

  resource_group_name = azurerm_resource_group.this.name
  location            = azurerm_resource_group.this.location

  name = var.name
  size = var.size

  admin_username = var.admin_username
  admin_password = var.admin_password

  os_disk                = var.os_disk
  source_image_reference = var.source_image_reference

  nic_ip_configuration = {
    name                          = var.nic_ip_configuration.name
    subnet_id                     = azurerm_subnet.this.id
    private_ip_address_allocation = var.nic_ip_configuration.private_ip_address_allocation
  }
}