
resource "proxmox_vm_qemu" "vm" {
  name        = var.vm_name
  desc        = var.vm_description
  target_node = var.target_node
  pool        = var.resource_pool
  clone       = var.template_name
  agent       = 1
  vmid        = var.vmid
  os_type     = "cloud-init"
  cores       = var.cpu_cores
  sockets     = var.cpu_sockets
  vcpus       = var.vcpus
  cpu         = "host"
  memory      = var.memory
  scsihw      = "lsi"

  disks {
    dynamic "virtio" {
      for_each = var.disks
      content {
        virtio {
          disk {
            size         = virtio.value.size
            storage      = virtio.value.storage
            storage_type = lookup(virtio.value, "storage_type", "lvm")
            iothread     = lookup(virtio.value, "iothread", true)
            discard      = lookup(virtio.value, "discard", true)
          }
        }
      }
    }
    ide {
      ide3 {
        cloudinit {
          storage = var.cloudinit_storage
        }
      }
    }
  }

  dynamic "network" {
    for_each = var.network_adapters
    content {
      model  = network.value.model
      bridge = network.value.bridge
      tag    = network.value.vlan_tag
    }
  }

  boot     = var.boot_order
  ipconfig0 = var.ipconfig
  sshkeys   = var.ssh_keys
}

# variables.tf

variable "vm_name" {
  type        = string
  description = "Name of the VM"
}

variable "vmid" {
  type        = number
  description = "ID of the VM"
}

variable "vm_description" {
  type        = string
  description = "Description of the VM"
}

variable "target_node" {
  type        = string
  description = "Target Proxmox node for the VM"
}

variable "resource_pool" {
  type        = string
  description = "Resource pool for the VM"
}

variable "template_name" {
  type        = string
  description = "Name of the template to clone from"
  default     = "ubuntu2204-withdocker"
}

variable "cpu_cores" {
  type        = number
  description = "Number of CPU cores"
  default     = 2
}

variable "cpu_sockets" {
  type        = number
  description = "Number of CPU sockets"
  default     = 1
}

variable "vcpus" {
  type        = number
  description = "Number of vCPUs"
  default     = 0
}

variable "memory" {
  type        = number
  description = "Amount of memory in MB"
  default     = 2048
}

variable "cloudinit_storage" {
  type        = string
  description = "Storage for cloud-init drive"
}

variable "disks" {
  type = list(object({
    size         = number
    storage      = string
    storage_type = optional(string)
    iothread     = optional(bool)
    discard      = optional(bool)
  }))
  description = "List of disks to attach to the VM"
}

variable "network_adapters" {
  type = list(object({
    model     = string
    bridge    = string
    vlan_tag  = number
  }))
  description = "List of network adapters"
  default = [
    {
      model    = "virtio"
      bridge   = "vmbr0"
      vlan_tag = 0
    }
  ]
}

variable "boot_order" {
  type        = string
  description = "Boot order for the VM"
  default     = "order=virtio0"
}

variable "ipconfig" {
  type        = string
  description = "IP configuration for the VM"
}

variable "ssh_keys" {
  type        = string
  description = "SSH keys for the VM"
}

# outputs.tf

output "vm_id" {
  value       = proxmox_vm_qemu.vm.id
  description = "The ID of the VM"
}

output "vm_name" {
  value       = proxmox_vm_qemu.vm.name
  description = "The name of the VM"
}

output "vm_ip" {
  value       = proxmox_vm_qemu.vm.default_ipv4_address
  description = "The default IPv4 address of the VM"
}