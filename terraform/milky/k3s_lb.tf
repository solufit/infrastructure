resource "proxmox_lxc" "k3s-lb-1" {
  hostname    = "solufit-k3s-lb-1"
  description = "Management Kubernetes Cluster LoadBalancer"
  target_node = "milky-capella"

  vmid = 12001

  clone = 9100

  start = true

  rootfs {
    storage = "local-lvm"
    size    = "8G"
  }

  # The destination resource pool for the new VM
  pool = "solufit"

  memory = 256
  cores  = 1

  onboot          = true
  ssh_public_keys = <<EOF
${var.ssh_public_key}
${var.ssh_public_key_k3s}
  EOF


  network {
    name     = "eth0"
    bridge   = "k3s"
    firewall = false
    ip       = "10.100.0.5/24"
    mtu      = 1400
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
  description = "Management Kubernetes Cluster LoadBalancer"
  target_node = "milky-carina"

  ssh_public_keys = <<EOF
${var.ssh_public_key}
${var.ssh_public_key_k3s}
  EOF
  vmid            = 12002

  clone = 9101

  start = true

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
    mtu      = 1400
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
  description = "Management Kubernetes Cluster LoadBalancer"
  target_node = "milky-capella"

  vmid = 12002

  clone = 9102

  start = true

  ssh_public_keys = <<EOF
${var.ssh_public_key}
${var.ssh_public_key_k3s}
  EOF

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
    mtu      = 1400
  }
  network {
    name     = "eth1"
    bridge   = "vmbr2"
    firewall = false
    ip       = "dhcp"
    mtu      = 1400
  }

}


