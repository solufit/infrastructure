# Proxmox LXC Container Module

This module creates a Proxmox LXC container with configurable settings including multiple rootfs, mountpoints, and network configurations.

## Usage

```hcl
module "proxmox_lxc" {
  source = "./proxmox-lxc-module"

  target_node    = "pve"
  hostname       = "lxc-example"
  ostemplate     = "local:vztmpl/ubuntu-20.04-standard_20.04-1_amd64.tar.gz"
  ssh_public_keys = "ssh-rsa <public_key_1> user@example.com\nssh-ed25519 <public_key_2> user@example.com"

  rootfs = [
    {
      storage = "local-zfs"
      size    = "8G"
    },
    {
      storage = "local-lvm"
      size    = "4G"
    }
  ]

  mountpoints = [
    {
      key     = "0"
      slot    = 0
      storage = "local-lvm"
      mp      = "/mnt/container/storage-backed-mount-point"
      size    = "12G"
    },
    {
      key     = "1"
      slot    = 1
      storage = "/srv/host/bind-mount-point"
      volume  = "/srv/host/bind-mount-point"
      mp      = "/mnt/container/bind-mount-point"
      size    = "256G"
    }
  ]

  networks = [
    {
      name   = "eth0"
      bridge = "vmbr0"
      ip     = "dhcp"
      ip6    = "dhcp"
    },
    {
      name   = "eth1"
      bridge = "vmbr1"
      ip     = "192.168.1.100/24"
      ip6    = "auto"
    }
  ]

  clone = "8001"
}
```

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| target_node | The target node for the LXC container | `string` | n/a | yes |
| hostname | The hostname of the LXC container | `string` | n/a | yes |
| ostemplate | The OS template for the LXC container | `string` | n/a | yes |
| unprivileged | Whether the container is unprivileged | `bool` | `true` | no |
| ostype | The OS type of the container | `string` | `"ubuntu"` | no |
| ssh_public_keys | SSH public keys for the container | `string` | n/a | yes |
| rootfs | List of root filesystems for the container | `list(object)` | n/a | yes |
| mountpoints | List of mountpoints for the container | `list(object)` | `[]` | no |
| networks | List of network interfaces for the container | `list(object)` | n/a | yes |
| clone | The ID of the container to clone from | `string` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| container_id | The ID of the created LXC container |
| container_hostname | The hostname of the created LXC container |