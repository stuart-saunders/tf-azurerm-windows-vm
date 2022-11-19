virtual_machines = {
  vm1 = {
    name = "vm1"
    resource_group_name = ""
    location = ""

    size = ""
    admin_username = "adminuser"

    os_disk = {
      name                 = "example_vm1-os"
      caching              = "ReadWrite"
      storage_account_type = "Standard_LRS"
    }

    source_image_reference = {
      publisher = "MicrosoftWindowsServer"
      offer     = "WindowsServer"
      sku       = "2019-Datacenter"
      version   = "latest"
    }

    network_interfaces = {
      
    }
  }
}