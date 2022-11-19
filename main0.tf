resource "azurerm_network_interface" "this" {
  name                = "${var.name}-nic"
  location            = var.resource_group.location
  resource_group_name = var.resource_group.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = var.subnet_id
    private_ip_address_allocation = "Dynamic"
  }

  tags = var.tags
}

resource "azurerm_windows_virtual_machine" "this" {
  name                = var.name
  resource_group_name = var.resource_group_name
  location            = var.location != null ? var.location : var.resource_group_location

  size                = var.size
  admin_username      = var.admin_username
  admin_password      = var.admin_password
  network_interface_ids = var.network_interface_ids

  os_disk {
    name = var.os_disk.name
    caching = var.os_disk.caching
    storage_account_type = var.os_disk.storage_account_type
    disk_size_gb = var.os_disk.disk_size_gb

    disk_encryption_set_id = var.os_disk.disk_encryption_set_id
    secure_vm_disk_encryption_set_id = var.os_disk.secure_vm_disk_encryption_set_id
  }

  availability_set_id = var.availability_set_id

  dynamic "boot_diagnostics" {
    count = var.boot_diagnostics != null ? 1 : 0
    
    storage_account_uri = var.boot_diagnostics.storage_account_uri
  }

  source_image_id = var.source_image_id

  dynamic "source_image_reference" {
    count = var.source_image_reference != null ? 1 : 0
    # for_each = var.source_image_reference != null ? [1] : []

    publisher = var.source_image_reference.publisher
    offer     = var.source_image_reference.offer
    sku       = var.source_image_reference.sku
    version   = var.source_image_reference.version
  }
}