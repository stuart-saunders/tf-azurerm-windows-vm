variable "resource_group_name" {
  type        = string
  description = "The name the Resource Group in which to create the Virtual Network"
}

variable "location" {
  type        = string
  description = "The Azure region in which the Resource Group should be created"
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

variable "name" {
  type        = string
  description = "The VM name"
}

variable "size" {
  type = string
}

variable "os_disk" {
  type = object({
    name                 = string
    caching              = string
    storage_account_type = string
  })
}

variable "source_image_reference" {
  type = object({
    publisher = string
    offer     = string
    sku       = string
    version   = string
  })
}

variable "admin_username" {
  type = string
}

variable "admin_password" {
  type = string
}

variable "nic_ip_configuration" {
  type = object({
    name                          = string
    private_ip_address_allocation = string
  })
}