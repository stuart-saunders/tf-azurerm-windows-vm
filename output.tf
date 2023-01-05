output "network_interface_id" {
  value = azurerm_network_interface.this != [] ? azurerm_network_interface.this[0].id : null
}

output "id" {
  value = azurerm_windows_virtual_machine.this.id
}