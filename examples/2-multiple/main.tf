resource "azurerm_resource_group" "this" {
  name     = var.resource_group.name
  location = var.resource_group.location
}

resource "azurerm_virtual_network" "this" {
  for_each = local.vnets

  name                = each.value.name
  address_space       = each.value.address_space
  location            = azurerm_resource_group.this.location
  resource_group_name = azurerm_resource_group.this.name
}

resource "azurerm_subnet" "this" {
  for_each = local.subnets

  name                 = each.value.name
  resource_group_name  = azurerm_resource_group.this.name
  virtual_network_name = azurerm_virtual_network.this[each.value.vnet_name].name
  address_prefixes     = each.value.address_prefixes
}

resource "azurerm_network_security_group" "this" {
  name                = "remote-connection-nsg"
  location            = azurerm_resource_group.this.location
  resource_group_name = azurerm_resource_group.this.name

  security_rule {
    name                       = "allow-rdp"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "3389"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

resource "azurerm_subnet_network_security_group_association" "this" {
  for_each = local.subnets

  subnet_id                 = azurerm_subnet.this[each.key].id
  network_security_group_id = azurerm_network_security_group.this.id
}

resource "azurerm_public_ip" "this" {
  for_each = local.vms

  name                = "${each.value.name}-ip"
  resource_group_name = azurerm_resource_group.this.name
  location            = azurerm_resource_group.this.location
  allocation_method   = "Static"
}

module "vm" {
  source   = "../../"
  for_each = local.vms

  resource_group_name = azurerm_resource_group.this.name
  location            = azurerm_resource_group.this.location

  name = each.value.name
  size = each.value.size

  admin_username = each.value.admin_username
  admin_password = each.value.admin_password

  os_disk                = each.value.os_disk
  source_image_reference = each.value.source_image_reference

  network_interface = {
    name     = try(each.value.network_interface.name, null)
    location = try(each.value.network_interface.location, null)

    enable_ip_forwarding = try(each.value.network_interface.enable_ip_forwarding, null)

    ip_configuration = {
      name                          = try(each.value.network_interface.ip_configuration.name, null)
      private_ip_address_allocation = try(each.value.network_interface.ip_configuration.private_ip_address_allocation, null)

      subnet_id            = azurerm_subnet.this[each.value.subnet_key].id
      public_ip_address_id = azurerm_public_ip.this[each.key].id

      primary = try(each.value.network_interface.ip_configuration.primary, null)
    }
  }
}