variable "target_node" {
  type        = string
  description = "The target node for the LXC container"
}

variable "hostname" {
  type        = string
  description = "The hostname of the LXC container"
}

variable "ostemplate" {
  type        = string
  description = "The OS template for the LXC container"
}

variable "unprivileged" {
  type        = bool
  description = "Whether the container is unprivileged"
  default     = true
}

variable "ostype" {
  type        = string
  description = "The OS type of the container"
  default     = "ubuntu"
}

variable "ssh_public_keys" {
  type        = string
  description = "SSH public keys for the container"
}

variable "rootfs" {
  type = list(object({
    storage = string
    size    = string
  }))
  description = "List of root filesystems for the container"
}

variable "mountpoints" {
  type = list(object({
    key     = string
    slot    = number
    storage = string
    mp      = string
    size    = string
    volume  = optional(string)
  }))
  description = "List of mountpoints for the container"
  default     = []
}

variable "networks" {
  type = list(object({
    name   = string
    bridge = string
    ip     = string
    ip6    = string
  }))
  description = "List of network interfaces for the container"
}

variable "clone" {
  type        = string
  description = "The ID of the container to clone from"
  default     = null
}

# outputs.tf (変更なし)
output "container_id" {
  value       = proxmox_lxc.container.id
  description = "The ID of the created LXC container"
}

output "container_hostname" {
  value       = proxmox_lxc.container.hostname
  description = "The hostname of the created LXC container"
}
