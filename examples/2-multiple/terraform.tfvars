# resource_group_name = "rg-vm-module-test"
# location            = "uksouth"

resource_group = {
  name     = "rg-vm-module-test"
  location = "uksouth"
}

vnets = [
  {
    name          = "vnet1"
    address_space = ["10.0.0.0/16"]

    subnets = [
      {
        name             = "subnet1"
        address_prefixes = ["10.0.1.0/24"]

        vms = [
          {
            name = "vm1"
            size = "Standard_B2s"

            admin_username = "adminuser"
            admin_password = "p@ssw0rd1234!!"

            os_disk = {
              name                 = "vm1-os"
              caching              = "ReadWrite"
              storage_account_type = "Standard_LRS"
            }

            source_image_reference = {
              publisher = "MicrosoftWindowsServer"
              offer     = "WindowsServer"
              sku       = "2019-Datacenter"
              version   = "latest"
            }

            network_interface = {
              ip_configuration = {
                name                          = "internal"
                private_ip_address_allocation = "Dynamic"
              }
            }
          }
        ]
      }
    ]
  },
  {
    name          = "vnet2"
    address_space = ["10.1.0.0/16"]

    subnets = [
      {
        name             = "subnet1"
        address_prefixes = ["10.1.1.0/24"]

        vms = [
          {
            name = "vm1a"
            size = "Standard_B2s"

            admin_username = "adminuser"
            admin_password = "p@ssw0rd1234!!"

            os_disk = {
              name                 = "vm1-os"
              caching              = "ReadWrite"
              storage_account_type = "Standard_LRS"
            }

            source_image_reference = {
              publisher = "MicrosoftWindowsServer"
              offer     = "WindowsServer"
              sku       = "2019-Datacenter"
              version   = "latest"
            }

            network_interface = {
              ip_configuration = {
                name                          = "internal"
                private_ip_address_allocation = "Dynamic"
              }
            }
          },
          {
            name = "vm1b"
            size = "Standard_B2s"

            admin_username = "adminuser"
            admin_password = "p@ssw0rd1234!!"

            os_disk = {
              name                 = "vm1-os"
              caching              = "ReadWrite"
              storage_account_type = "Standard_LRS"
            }

            source_image_reference = {
              publisher = "MicrosoftWindowsServer"
              offer     = "WindowsServer"
              sku       = "2019-Datacenter"
              version   = "latest"
            }

            network_interface = {
              ip_configuration = {
                name                          = "internal"
                private_ip_address_allocation = "Dynamic"
              }
            }
          }
        ]
      },
      {
        name             = "subnet2"
        address_prefixes = ["10.1.2.0/24"]

        vms = [
          {
            name = "vm2a"
            size = "Standard_B2s"

            admin_username = "adminuser"
            admin_password = "p@ssw0rd1234!!"

            os_disk = {
              name                 = "vm2-os"
              caching              = "ReadWrite"
              storage_account_type = "Standard_LRS"
            }

            source_image_reference = {
              publisher = "MicrosoftWindowsServer"
              offer     = "WindowsServer"
              sku       = "2019-Datacenter"
              version   = "latest"
            }

            network_interface = {
              ip_configuration = {
                name                          = "internal"
                private_ip_address_allocation = "Dynamic"
              }
            }
          },
          {
            name = "vm2b"
            size = "Standard_B2s"

            admin_username = "adminuser"
            admin_password = "p@ssw0rd1234!!"

            os_disk = {
              name                 = "vm2-os"
              caching              = "ReadWrite"
              storage_account_type = "Standard_LRS"
            }

            source_image_reference = {
              publisher = "MicrosoftWindowsServer"
              offer     = "WindowsServer"
              sku       = "2019-Datacenter"
              version   = "latest"
            }

            network_interface = {
              ip_configuration = {
                name                          = "internal"
                private_ip_address_allocation = "Dynamic"
              }
            }
          }
        ]
      }
    ]
  }
]

