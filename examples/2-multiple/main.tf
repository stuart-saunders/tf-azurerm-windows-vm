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

module "vm" {
  source = "../../"
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
    ip_configuration = {
      name                          = each.value.network_interface.ip_configuration.name
      private_ip_address_allocation = each.value.network_interface.ip_configuration.private_ip_address_allocation
      subnet_id                     = azurerm_subnet.this[each.value.subnet_key].id
    }
  }
}