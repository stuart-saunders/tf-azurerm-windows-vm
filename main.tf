resource "azurerm_network_interface" "this" {
  name                = "${var.name}-nic"
  location            = var.location
  resource_group_name = var.resource_group_name

  ip_configuration {
    name                          = var.nic_ip_configuration.name
    subnet_id                     = var.nic_ip_configuration.subnet_id
    private_ip_address_allocation = var.nic_ip_configuration.private_ip_address_allocation
  }

  tags = var.tags
}

resource "azurerm_windows_virtual_machine" "this" {
  name                = var.name
  resource_group_name = var.resource_group_name
  location            = var.location

  size           = var.size
  admin_username = var.admin_username
  admin_password = var.admin_password

  network_interface_ids = setunion(
    [azurerm_network_interface.this.id],
    var.network_interface_ids
  )

  os_disk {
    name = try(var.os_disk.name, null)

    caching              = var.os_disk.caching
    storage_account_type = var.os_disk.storage_account_type

    dynamic "diff_disk_settings" {
      for_each = var.os_disk.diff_disk_settings == null ? [] : [1]

      content {
        option    = var.os_disk.diff_disk_settings.option
        placement = try(var.os_disk.diff_disk_settings.placement, null)
      }
    }

    disk_encryption_set_id           = try(var.os_disk.disk_encryption_set_id, null)
    disk_size_gb                     = try(var.os_disk.disk_size_gb)
    secure_vm_disk_encryption_set_id = try(var.os_disk.secure_vm_disk_encryption_set_id, null)
    security_encryption_type         = try(var.os_disk.security_encryption_type, null)
    write_accelerator_enabled        = try(var.os_disk.write_accelerator_enabled, null)
  }

  source_image_id = var.source_image_id

  dynamic "source_image_reference" {
    for_each = var.source_image_reference == null ? [] : [1]

    content {
      publisher = var.source_image_reference.publisher
      offer     = var.source_image_reference.offer
      sku       = var.source_image_reference.sku
      version   = var.source_image_reference.version
    }
  }

  dynamic "additional_capabilities" {
    for_each = var.additional_capabilities == null ? [] : [1]

    content {
      ultra_ssd_enabled = var.additional_capabilities.ultra_ssd_enabled
    }
  }

  dynamic "additional_unattend_content" {
    for_each = var.additional_unattend_content == null ? [] : [1]

    content {
      content = var.additional_unattend_content.content
      setting = var.additional_unattend_content.setting
    }
  }

  allow_extension_operations = var.allow_extension_operations
  availability_set_id        = var.availability_set_id

  dynamic "boot_diagnostics" {
    for_each = var.boot_diagnostics == null ? [] : [1]

    content {
      storage_account_uri = try(var.boot_diagnostics.storage_account, null)
    }
  }

  capacity_reservation_group_id = var.capacity_reservation_group_id
  computer_name                 = var.computer_name
  custom_data                   = var.custom_data
  dedicated_host_id             = var.dedicated_host_id
  edge_zone                     = var.edge_zone
  enable_automatic_updates      = var.enable_automatic_updates
  encryption_at_host_enabled    = var.encryption_at_host_enabled
  eviction_policy               = var.eviction_policy

  dynamic "gallery_application" {
    for_each = var.gallery_application == null ? [] : [1]

    content {
      version_id             = var.gallery_application.version_id
      configuration_blob_uri = try(var.gallery_application.configuration_blob_uri, null)
      order                  = try(var.gallery_application.order, null)
      tag                    = try(var.gallery_application.tag, null)
    }
  }

  hotpatching_enabled = var.hotpatching_enabled

  dynamic "identity" {
    for_each = var.identity == null ? [] : [1]

    content {
      type         = var.identity.type
      identity_ids = try(var.identity.identity_ids, null)
    }
  }

  license_type          = var.license_type
  max_bid_price         = var.max_bid_price
  patch_assessment_mode = var.patch_assessment_mode
  patch_mode            = var.patch_mode

  dynamic "plan" {
    for_each = var.plan == null ? [] : [1]

    content {
      name      = var.plan.name
      product   = var.plan.product
      publisher = var.plan.publisher
    }
  }

  platform_fault_domain        = var.platform_fault_domain
  priority                     = var.priority
  provision_vm_agent           = var.provision_vm_agent
  proximity_placement_group_id = var.proximity_placement_group_id

  dynamic "secret" {
    for_each = var.secret == null ? [] : [1]

    content {
      dynamic "certificate" {
        for_each = var.secret.certificate == null ? [] : [1]

        content {
          store = var.secret.certificate.store
          url   = var.secret.certificate.url
        }
      }

      key_vault_id = var.secret.key_vault_id
    }
  }

  secure_boot_enabled = var.secure_boot_enabled
  tags                = var.tags

  dynamic "termination_notification" {
    for_each = var.termination_notification == null ? [] : [1]

    content {
      enabled = var.termination_notification.enabled
      timeout = try(var.termination_notification.timeout, null)
    }
  }

  timezone                     = var.timezone
  user_data                    = var.user_data
  virtual_machine_scale_set_id = var.virtual_machine_scale_set_id
  vtpm_enabled                 = var.vtpm_enabled

  dynamic "winrm_listener" {
    for_each = var.winrm_listener == null ? [] : [1]

    content {
      protocol        = var.winrm_listener.protocol
      certificate_url = try(var.winrm_listener.certificate_url, null)
    }
  }

  zone = var.zone

  lifecycle {
    ignore_changes = [
      os_disk[0].name,
      admin_username,
      admin_password
    ]
  }
}