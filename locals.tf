locals {

  defaults = {
    network_interface = {
      name = "${var.name}-nic"
      ip_configuration = {
        name                          = "internal"
        private_ip_address_allocation = "Dynamic"
      }
    }

    os_disk = {
      name = "${var.name}-osdisk"
    }
  }

}