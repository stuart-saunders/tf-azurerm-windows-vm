resource "azurerm_windows_virtual_machine" "this" {
  # depends_on = []
  for_each = var.virtual_machines

  name = each.value.name
  resource_group_name = ""
  location = ""

  size = ""
  admin_username = ""
  admin_password = ""
  # network_interface_ids

  os_disk {
    name = try(each.value.os_disk.name, null)
    
    caching = each.value.os_disk.caching
    storage_account_type = each.value.os_disk.storage_account_type

    dynamic "diff_disk_settings" {
      for_each = try(each.value.diff_disk_settings, null) ? [1] : []

      content {
        option = each.value.diff_disk_settings.option
        placement = try(each.value.diff_disk_settings.placement, null)
      }
    }

    disk_encryption_set_id = try(each.value.os_disk.disk_encryption_set_id, null)
    disk_size_gb = try(each.value.os_disk.disk_size_gb)
    secure_vm_disk_encryption_set_id = try(each.value.os_disk_secure_vm_disk_encryption_set_id, null)
    security_encryption_type = try(each.value.os_disk.security_encryption_type, null)
    write_accelerator_enabled = try(each.value.os_disk.write_accelerator_enabled, null)
  }

  dynamic "source_image_reference" {
    for_each = try(each.value.source_image_reference, null) != null ? [1] : []

    content {
      publisher = try(each.value.source_image_reference.publisher, null)
      offer     = try(each.value.source_image_reference.offer, null)
      sku       = try(each.value.source_image_reference.sku, null)
      version   = try(each.value.source_image_reference.version, null)
    }
  }

  source_image_id = try(each.value.source_image_id, null)

  # custom_data = {
  
  # }

  allow_extension_operations = try(each.value.allow_extension_operations, null)
  availability_set_id = try(each.value.availability_set_id, null)
  computer_name = try(each.value.computer_name, null)
  dedicated_host_id = try(each.value.dedicated_host_id, null)
  enable_automatic_updates = try(each.value.enable_automatic_updates, null)
  encryption_at_host_enabled = try(each.value.encryption_at_host_enabled, null)
  eviction_policy = try(each.value.eviction_policy, null)
  licence_type = try(each.value.license_type, null)
  max_bid_price = try(each.value.max_bid_price, null)
  priority = try(each.value.priority, null)
  provision_vm_agent = try(each.value.provision_vm_agent, null)
  proximity_placement_group_id = try(each.value.proximity_placement_group_id, null)
  tags = try(each.value.tags, null)
  timezone = try(each.value.timezone, null)
  zone = try(each.value.zone, null)

  dynamic "additional_capabilities" {
    for_each = try(each.value.additional_capabilities, false) == false ? [] : [1]

    content {
      ultra_ssd_enabled = each.value.additional_capabilities.ultra_ssd_enabled
    }
  }

  dynamic "additional_unattend_content" {
    for_each = try(each.value.additional_unattend_content, false) == false ? [] : [1]

    content {
      content = each.value.additional_unattend_content.content
      setting = each.value.additional_unattend_content.setting
    }
  }

  dynamic "boot_diagnostics" {
    for_each = try(var.boot_diagnostics_storage_account != null ? [1] : var.global_settings.resource_defaults.virtual_machines.use_azmanaged_storage_for_boot_diagnostics == true ? [1] : [], [])

    content {
      storage_account_uri = var.boot_diagnostics_storage_account == "" ? null : var.boot_diagnostics_storage_account
    }
  }

#   dynamic "secret" {
#     for_each = try(each.value. , false) == false ? [] : [1]

#     content {
#       key_vault_id = 

#       dynamic "certificate" {
#         for_each = try(each.value., false) == false ? [] : [1]

#         content {
#           url   = azurerm_key_vault_certificate. ... .secret_id
#           store = ""
#         }
#       }
#     }
#   }

#   dynamic "identity" {
#     for_each = try(each.value.identity, false) == false ? [] : [1]

#     content {
#       type         = each.value.identity.type
#       identity_ids = local.managed_identities
#     }
#   }

  dynamic "plan" {
    for_each = try(each.value.plan, false) == false ? [] : [1]

    content {
      name      = each.value.plan.name
      product   = each.value.plan.product
      publisher = each.value.plan.publisher
    }
  }

#   dynamic "winrm_listener" {
#     for_each = try(each.value.winrm, false) == false ? [] : [1]

#     content {
#       protocol        = try(each.value.winrm.protocol, "Https")
#       certificate_url = try(each.value.winrm.enable_self_signed, false) ? azurerm_key_vault_certificate.self_signed_winrm[each.key].secret_id : each.value.winrm.certificate_url
#     }
#   }

  lifecycle {
    ignore_changes = [
      os_disk[0].name, # for ASR disk restores
      admin_username,  # Only used for initial deployment as it can be changed later by GPO
      admin_password   # Only used for initial deployment as it can be changed later by GPO
    ]
  }
}