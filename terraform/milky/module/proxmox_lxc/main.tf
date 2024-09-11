resource "proxmox_lxc" "container" {
  target_node  = var.target_node
  hostname     = var.hostname
  ostemplate   = var.ostemplate
  unprivileged = var.unprivileged
  ostype       = var.ostype
  ssh_public_keys = var.ssh_public_keys

  dynamic "rootfs" {
    for_each = var.rootfs
    content {
      storage = rootfs.value.storage
      size    = rootfs.value.size
    }
  }

  dynamic "mountpoint" {
    for_each = var.mountpoints
    content {
      key     = mountpoint.value.key
      slot    = mountpoint.value.slot
      storage = mountpoint.value.storage
      mp      = mountpoint.value.mp
      size    = mountpoint.value.size
      volume  = lookup(mountpoint.value, "volume", null)
    }
  }

  dynamic "network" {
    for_each = var.networks
    content {
      name   = network.value.name
      bridge = network.value.bridge
      ip     = network.value.ip
      ip6    = network.value.ip6
    }
  }

  clone = var.clone
}