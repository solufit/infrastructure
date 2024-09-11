# outputs.tf (変更なし)
output "container_id" {
  value       = proxmox_lxc.container.id
  description = "The ID of the created LXC container"
}

output "container_hostname" {
  value       = proxmox_lxc.container.hostname
  description = "The hostname of the created LXC container"
}