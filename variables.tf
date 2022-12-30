variable "name" {
  description = "The name to assign to the VM"
  type        = string
  validation {
    condition     = can(regex("^[a-zA-Z0-9_-]{1,14}$", var.name))
    error_message = "The name can contain alphanumeric, `_` & `-` characters only and should be less than 14 characters (with no spaces)."
  }
}

variable "location" {
  type        = string
  description = "The Azure location where the VM should be created."
}

variable "resource_group_name" {
  type        = string
  description = "_(Required)_ The name the Resource Group in which to create the VM"
}

variable "admin_password" {
  type        = string
  description = "_(Required)_ The password to assign to the VM's Admin user account"
  sensitive   = true
}

variable "admin_username" {
  type        = string
  description = "The username to assign to the VM's Admin user account. Defaults to `adminuser`."
  default     = "adminuser"
  sensitive   = true
}

variable "network_interface_ids" {
  type        = list(string)
  description = "A list of Network Interface Ids which should be attached to this VM"
  default     = []
}

variable "os_disk" {
  type = object({
    caching              = string
    storage_account_type = string

    diff_disk_settings = optional(object({
      option    = string
      placement = optional(string, null)
    }), null)

    disk_encryption_set_id          = optional(string, null)
    disk_size_gb                    = optional(string, null)
    name                            = optional(string, null)
    secure_vm_disk_encyption_set_id = optional(string, null)
    security_encryption_type        = optional(string, null)
    write_accelerator_enabled       = optional(string, null)
  })
  description = <<-DESC
    Object to define the OS Disk configuration
    **caching**: _(Required)_ The Type of Caching which should be used for the Internal OS Disk. Possible values are `None`, `ReadOnly` and `ReadWrite`.
    **storage_account_type**: _(Required)_ The Type of Storage Account which should back this the Internal OS Disk. Possible values are Standard_LRS, StandardSSD_LRS, Premium_LRS, StandardSSD_ZRS and Premium_ZRS. 
    **diff_disk_settings**: An object to define ephemeral disk settings, containg the following values:-
      **option**: _(Required)_ Specifies the Ephemeral Disk Settings for the OS Disk. At this time the only possible value is `Local`.
      **placement**: Specifies where to store the Ephemeral Disk. Possible values are `CacheDisk` and `ResourceDisk`. Defaults to `CacheDisk`.
    **disk_encryption_set_id**: The ID of the Disk Encryption Set which should be used to Encrypt this OS Disk. Conflicts with _secure_vm_disk_encryption_set_id_.
    **disk_size_gb**: The size of the Internal OS Disk in GB
    **name**: The name which should be used for the Internal OS Disk
    **secure_vm_disk_encyption_set_id**: The ID of the Disk Encryption Set which should be used to Encrypt this OS Disk when the Virtual Machine is a Confidential VM. Conflicts with _disk_encryption_set_id_.
    **security_encryption_type**: Encryption Type when the Virtual Machine is a Confidential VM. Possible values are `VMGuestStateOnly` and `DiskWithVMGuestState`.
    **write_accelerator_enabled**: Specifies if Write Accelerator should be Enabled for this OS Disk
  DESC
}

variable "size" {
  type        = string
  description = "The SKU which should be used for this VM"
}

variable "nic_ip_configuration" {
  type = object({
    name                          = string
    subnet_id                     = string
    private_ip_address_allocation = string

    gateway_load_balancer_frontend_ip_configuration_id = optional(string)
    primary                                            = optional(bool)
    private_ip_address                                 = optional(string)
    private_ip_address_version                         = optional(string)
    public_ip_address_id                               = optional(string)
  })
  description = <<-DESC
    The IP Configuration of the Network Interface to be created for this VM.
    **name**: _(Required)_ The name for this IP Configuration
    **subnet_id**: _(Required)_ The ID of the subnet where this Network Interface should be located
    **private_ip_address_allocation**: _(Required)_ The allocation method used for the Private IP Address. Possible values are `Dynamic` and `Static`.
    **gateway_load_balancer_fronend_ip_configuration_id**: The Frontend IP Configuration ID of a Gateway SKU Load Balancer
    **primary**: To identify is this is the Primary IP Configuration
    **private_ip_address**: The static, private IP address for the Network Interface
    **private_ip_address_version**: The IP Version to use. Possible values are `IPv4` and `IPv6`.
    **public_ip_address_id**: Reference to a Public IP Address to associate with this NIC
  DESC
  default     = null
}

variable "additional_capabilities" {
  type = object({
    ultra_ssd_enabled = optional(bool, null)
  })
  description = "Object to enable support for data disks of the `UltraSSD_LRS` storage account type. Defaults to `false`."
  default     = null
}

variable "additional_unattend_content" {
  type = object({
    content = string
    setting = string
  })
  description = <<-DESC
    **content**: XML-formatted content that is added to an `unattend.xml` file for the specified path and component
    **setting**: The name of the setting to which the content applies. Possible values are `AutoLogon` and `FirstLogonCommands`.
  DESC
  default     = null
}

variable "allow_extension_operations" {
  type        = bool
  description = "Allows extension operations on the Virtual Machine"
  default     = null
}

variable "availability_set_id" {
  type        = string
  description = "Specifies the ID of the Availability Set in which the Virtual Machine should exist"
  default     = null
}

variable "boot_diagnostics" {
  type = object({
    storage_account_uri = optional(string, null)
  })
  description = "Configure a storage account for Boot Diagnostics"
  default     = null
}

variable "capacity_reservation_group_id" {
  type        = string
  description = <<-DESC
    Specifies the ID of the Capacity Reservation Group to which the Virtual Machine should be allocated
    **NOTE**: Cannot be used with _availability_set_id_ or _proximity_placement_group_id_
  DESC
  default     = null
}

variable "computer_name" {
  type        = string
  description = <<-DESC
    Specifies the Hostname which should be used for this Virtual Machine. 
    If unspecified this defaults to the value for the name field. 
    If the value of the name field is not a valid _computer_name_, then you must specify _computer_name_
  DESC
  default     = null
}

variable "custom_data" {
  type        = string
  description = "The Base64-Encoded Custom Data which should be used for this Virtual Machine"
  default     = null
}

variable "dedicated_host_id" {
  type        = string
  description = "The ID of a Dedicated Host on which this machine should be run"
  default     = null
}

variable "dedicated_host_group_id" {
  type        = string
  description = "The ID of a Dedicated Host Group that this Windows Virtual Machine should be run within"
  default     = null
}

variable "edge_zone" {
  type        = string
  description = "The Edge Zone within the Azure Region where this Windows Virtual Machine should exist"
  default     = null
}

variable "enable_automatic_updates" {
  type        = bool
  description = "Specifies if Automatic Updates are Enabled for the Windows Virtual Machine"
  default     = null
}

variable "encryption_at_host_enabled" {
  type        = bool
  description = "Allows all of the disks (including the temp disk) attached to this Virtual Machine to be encrypted by enabling Encryption at Host"
  default     = null
}

variable "eviction_policy" {
  type        = string
  description = <<-DESC
    Specifies what should happen when the Virtual Machine is evicted for price reasons when using a Spot instance.
    Possible values are `Deallocate` and `Delete`.
    **NOTE**: Can only be configured when priority is set to `Spot`.
  DESC
  default     = null
}

variable "extensions_time_budget" {
  type        = string
  description = <<-DESC
    Specifies the duration allocated for all extensions to start.
    The time duration should be between 15 minutes and 120 minutes (inclusive) and should be specified in ISO 8601 format.
    Defaults to 90 minutes (`PT1H30M`)
  DESC
  default     = null
}

variable "gallery_application" {
  type = object({
    version_id             = string
    configuration_blob_uri = optional(string, null)
    order                  = optional(string, null)
    tag                    = optional(string, null)
  })
  description = <<-DESC
    **version_id**: Specifies the Gallery Application Version resource ID
    **configuration_blob_uri**: Specifies the URI to an Azure Blob that will replace the default configuration for the package if provided
    **order**: Specifies the order in which the packages have to be installed. Possible values are between `0` and `2,147,483,647`.
    **tag**: Specifies a passthrough value for more generic context. This field can be any valid string value.
  DESC
  default     = null
}

variable "hotpatching_enabled" {
  type        = bool
  description = <<-DESC
    Allows the machine to be patched without requiring a reboot.
    Can only be enabled if:-
      - _patch_mode_ is set to `AutomaticByPlatform`
      - _provision_vm_agent_ is set to `true`
      - _source_image_reference_ references a hotpatching-enabled image
      - the VM size is set to a Gen2 VM
  DESC
  default     = null
}

variable "identity" {
  type = object({
    type         = string
    identity_ids = optional(list(string))
  })
  description = <<-DESC
    **type**: Specifies the type of Managed Service Identity that should be configured on this VM.
        Possible values are `SystemAssigned`, `UserAssigned`, `SystemAssigned, UserAssigned` (to enable both).
    **identity_ids**: Specifies a list of User Assigned Managed Identity IDs to be assigned to this VM.
    **NOTE**: This is required when type is set to `UserAssigned` or `SystemAssigned, UserAssigned`.
  DESC
  default     = null
}

variable "license_type" {
  type        = string
  description = <<-DESC
    Specifies the type of on-premises license which should be used for this Virtual Machine.
    Possible values are `None`, `Windows_Client` and `Windows_Server`.
  DESC
  default     = null
}

variable "max_bid_price" {
  type        = string
  description = <<-DESC
    The maximum price you're willing to pay for this Virtual Machine, in US Dollars; which must be greater than the current spot price. If this bid price falls below the current spot price the Virtual Machine will be evicted using the eviction_policy. Defaults to `-1`, which means that the Virtual Machine should not be evicted for price reasons.
    **NOTE**: Can only be configured when priority is set to `Spot`.
  DESC
  default     = null
}

variable "patch_assessment_mode" {
  type        = string
  description = <<-DESC
    Specifies the mode of VM Guest Patching for the Virtual Machine. Possible values are `AutomaticByPlatform` or `ImageDefault`. Defaults to `ImageDefault`.
    **NOTE**: If the _patch_assessment_mode_ is set to `AutomaticByPlatform` then the _provision_vm_agent_ field must be set to `true`.
  DESC
  default     = null
}

variable "patch_mode" {
  type        = string
  description = <<-DESC
    Specifies the mode of in-guest patching to this Windows Virtual Machine. Possible values are `Manual`, `AutomaticByOS` and `AutomaticByPlatform`. Defaults to `AutomaticByOS`.
    **NOTE**: If _patch_mode_ is set to `AutomaticByPlatform` then _provision_vm_agent_ must also be set to `true`. If the Virtual Machine is using a hotpatching enabled image the _patch_mode_ must always be set to `AutomaticByPlatform`.
  DESC
  default     = null
}

variable "plan" {
  type = object({
    name      = string
    product   = string
    publisher = string
  })
  description = <<-DESC
    **name**: Specifies the Name of the Marketplace Image from which this VM should be created
    **product**: Specifies the Product of the Marketplace Image from which this VM should be created
    **publisher**: Specifies the Publisher of the Marketplace Image from which this VM should be created
  DESC
  default     = null
}

variable "platform_fault_domain" {
  type        = string
  description = <<-DESC
    Specifies the Platform Fault Domain in which this VM should be created.
    Defaults to `-1`, which means this will be automatically assigned to a fault domain that best maintains balance across the available fault domains.
  DESC
  default     = null
}

variable "priority" {
  type        = string
  description = "Specifies the priority of this VM. Possible values are `Regular` and `Spot`. Defaults to `Regular`."
  default     = null
}

variable "provision_vm_agent" {
  type        = bool
  description = "Specifies if the Azure VM Agent should be provisioned on this VM"
  default     = null
}

variable "proximity_placement_group_id" {
  type        = string
  description = "The Id of the Proximity Placement Group to which the VM should be assigned"
  default     = null
}

variable "secret" {
  type = object({
    certificate = optional(object({
      store = string
      url   = string
    }), null)
    key_vault_id = string
  })
  description = <<-DESC
    The certificate object should contain the values:-
      **store**: The certificate store on the VM where the certificate should be added
      **url**: The Secret URL of a Key Vault Certificate
  DESC
  default     = null
}

variable "secure_boot_enabled" {
  type        = string
  description = "Specifies if Secure Boot and Trusted Launch is enabled for the VM"
  default     = null
}

variable "source_image_id" {
  type        = string
  description = "The Id of the Image from which this VM should be created"
  default     = null
}

variable "source_image_reference" {
  type = object({
    publisher = string
    offer     = string
    sku       = string
    version   = string
  })
  description = <<-DESC
    **publisher**: The publisher of the image used to create the VM
    **offer**: The offer of the image used to create the VM
    **sku**: The SKU of the image used to create the VM
    **version**: The version of the image used to create the VM
  DESC
  default     = null
}

variable "tags" {
  type        = map(string)
  description = "A map of the tags that should be applied to the VM"
  default     = null
}

variable "termination_notification" {
  type = object({
    enabled = bool
    timeout = optional(string, null)
  })
  description = <<-DESC
    **enabled**: enables the termination notification on the VM
    **timeout: Length of time (in minutes, between 5 and 15) a notification to be sent to the VM on the instance metadata server until the VM gets deleted. The time duration should be specified in ISO 8601 format. Defaults to `PT5M`.
  DESC
  default     = null
}

variable "timezone" {
  type        = string
  description = "Specifies the Time Zone which should be used by the VM"
  default     = null
}

variable "user_data" {
  type        = string
  description = "The Base64-Encoded User Data which should be used for this VM"
  default     = null
}

variable "virtual_machine_scale_set_id" {
  type        = string
  description = "Specifies the Orchestrated Virtual Machine Scale Set in which this VM should be created"
  default     = null
}

variable "vtpm_enabled" {
  type        = bool
  description = "Specifies if vTPM (virtual Trusted Platform Module) and Trusted Launch is enabled for the VM"
  default     = null
}

variable "winrm_listener" {
  type = object({
    protocol        = string
    certificate_url = optional(string, null)
  })
  description = <<-DESC
    **protocol**: Specifies the protocol of listener - possible values are `Http` or `Https`
    **certificate_url**: The Secret URL of a Key Vault Certificate, which must be specified when protocol is set to `Https`
  DESC
  default     = null
}

variable "zone" {
  type        = string
  description = "The Availability Zone in which this VM should be located"
  default     = null
}