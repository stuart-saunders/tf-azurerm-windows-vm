variable "resource_group" {
  type = object({
    name = string
    location = string
  })
}

variable "vnet" {
  type = object({
    name          = string
    address_space = list(string)

    subnet = object({
      name             = string
      address_prefixes = list(string)
    })
  })
}

variable "vm" {
  type = object({
    name = string
    size = string

    os_disk = object({
      name                 = string
      caching              = string
      storage_account_type = string
    })

    source_image_reference = object({
      publisher = string
      offer     = string
      sku       = string
      version   = string
    })

    admin_username = string
    admin_password = string

    network_interface = object({
      name = optional(string, null)

      ip_configuration = object({
        name = string
        private_ip_address_allocation = string
      })
    })
  })
}