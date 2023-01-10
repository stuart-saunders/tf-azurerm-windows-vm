variable "resource_group" {
  type = object({
    name     = string
    location = string
  })
}

variable "vnets" {
  type = list(object({
    name          = string
    address_space = list(string)

    subnets = list(object({
      name             = string
      address_prefixes = list(string)

      vms = list(object({
        name = string
        size = string

        os_disk = object({
          name                 = optional(string, null)
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

        network_interface = optional(object({
          name                 = optional(string, null)
          location             = optional(string, null)
          enable_ip_forwarding = optional(bool, null)

          ip_configuration = optional(object({
            name                          = optional(string, null)
            private_ip_address_allocation = optional(string, null)
            primary                       = optional(bool, null)
          }), {})
        }), {})

        network_interface_ids = optional(list(string), null)
      }))
    }))
  }))
}