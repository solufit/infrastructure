
resource "proxmox_lxc" "k3s-lb-1" {
  hostname    = "solufit-k3s-lb-1"
  description = "cloudflare tunnel for Solufit"
  target_node = "milky-capella"

  vmid = 12001

  clone = 9100

  start = true

  rootfs {
    storage = "local-lvm"
    size    = "8G"
  }
  ssh_public_keys = <<EOT
${var.ssh_public_key}
${var.ssh_public_key_k3s}
  EOT
  # The destination resource pool for the new VM
  pool = "solufit"

  memory = 256
  cores  = 1

  onboot = true


  network {
    name     = "eth0"
    bridge   = "k3s"
    firewall = false
    ip       = "10.100.0.5/24"
  }
  network {
    name     = "eth1"
    bridge   = "vmbr2"
    firewall = false
    ip       = "dhcp"
    mtu      = 1400
  }

}




resource "proxmox_lxc" "k3s-lb-2" {
  hostname    = "solufit-k3s-lb-2"
  description = "cloudflare tunnel for Solufit"
  target_node = "milky-carina"

  vmid = 12002

  clone = 9101

  start           = true
  ssh_public_keys = <<EOT
${var.ssh_public_key}
${var.ssh_public_key_k3s}
  EOT
  rootfs {
    storage = "local-lvm"
    size    = "8G"
  }

  # The destination resource pool for the new VM
  pool = "solufit"

  memory = 256
  cores  = 1

  onboot = true


  network {
    name     = "eth0"
    bridge   = "k3s"
    firewall = false
    ip       = "10.100.0.6/24"
  }
  network {
    name     = "eth1"
    bridge   = "vmbr2"
    firewall = false
    ip       = "dhcp"
    mtu      = 1400
  }

}


resource "proxmox_lxc" "k3s-lb-3" {
  hostname    = "solufit-k3s-lb-3"
  description = "cloudflare tunnel for Solufit"
  target_node = "milky-polaris"

  vmid = 12003

  clone = 9102

  start           = true
  ssh_public_keys = <<EOT
${var.ssh_public_key}
${var.ssh_public_key_k3s}
  EOT
  rootfs {
    storage = "local-lvm"
    size    = "8G"
  }

  # The destination resource pool for the new VM
  pool = "solufit"

  memory = 256
  cores  = 1

  onboot = true


  network {
    name     = "eth0"
    bridge   = "k3s"
    firewall = false
    ip       = "10.100.0.7/24"
  }
  network {
    name     = "eth1"
    bridge   = "vmbr2"
    firewall = false
    ip       = "dhcp"
    mtu      = 1400
  }

}