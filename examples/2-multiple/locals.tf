locals {

  vnets = { for vnet in var.vnets :
    vnet.name => vnet
  }

  subnets = merge([for vnet in local.vnets :
    {
      for subnet in vnet.subnets :
      "${vnet.name}_${subnet.name}" => {
        vnet_name        = vnet.name
        name             = subnet.name
        address_prefixes = subnet.address_prefixes
        vms              = subnet.vms
      }
    }
  ]...)

  vms = merge([for subnet_key, subnet in local.subnets :
    {
      for vm in subnet.vms :
      "${subnet.vnet_name}_${subnet.name}_${vm.name}" => {
        vnet_name   = subnet.vnet_name
        subnet_key  = subnet_key
        subnet_name = subnet.name

        name = vm.name
        size = vm.size

        admin_username = vm.admin_username
        admin_password = vm.admin_password

        os_disk                = vm.os_disk
        source_image_reference = vm.source_image_reference

        network_interface = vm.network_interface
      }
    }
  ]...)
}