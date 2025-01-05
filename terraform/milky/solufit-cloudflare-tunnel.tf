# Cloud Flare Tunnel Settings
/* Uses Cloud-Init options from Proxmox 5.2 */
variable "cloudflare_provision" {
  type      = string
  sensitive = true
}

variable "cloudflare_provision_2" {
  type      = string
  sensitive = true
}
resource "proxmox_lxc" "cloudflare-tunnel-solufit-1" {
  hostname    = "solufit-cloudflare-tunnel-1"
  description = "cloudflare tunnel for Solufit"
  target_node = "milky-capella"

  vmid = 2003

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

  onboot = true


  network {
    name     = "eth0"
    bridge   = "evnet1"
    firewall = false
    ip       = "10.0.0.50/24"
  }
  network {
    name     = "eth1"
    bridge   = "vmbr2"
    firewall = false
    ip       = "dhcp"
    mtu      = 1400
  }

  provisioner "remote-exec" {
    connection {
      type        = "ssh"
      user        = "root"
      private_key = var.ssh_private_key
      host        = "10.0.0.50"
    }
    inline = [
      "apt-get update && apt-get upgrade -y && apt-get install -y curl",
      "echo '#! /bin/sh' > /tmp/cloudflare-provision.sh",
      "echo '${var.cloudflare_provision}' >> /tmp/cloudflare-provision.sh",
      "chmod +x /tmp/cloudflare-provision.sh",
      "sudo /tmp/cloudflare-provision.sh"
    ]

  }
}

resource "proxmox_lxc" "cloudflare-tunnel-solufit-2" {
  hostname    = "solufit-cloudflare-tunnel-2"
  description = "cloudflare tunnel for Solufit"
  target_node = "milky-carina"

  vmid = 2004

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
    bridge   = "evnet1"
    firewall = false
    ip       = "10.0.0.51/24"
  }
  network {
    name     = "eth1"
    bridge   = "vmbr2"
    firewall = false
    ip       = "dhcp"
    mtu      = 1400
  }

  provisioner "remote-exec" {
    connection {
      type        = "ssh"
      user        = "root"
      private_key = var.ssh_private_key
      host        = "10.0.0.51"
    }
    inline = [
      "apt-get update && apt-get upgrade -y && apt-get install -y curl",
      "echo '#! /bin/sh' > /tmp/cloudflare-provision.sh",
      "echo '${var.cloudflare_provision}' >> /tmp/cloudflare-provision.sh",
      "chmod +x /tmp/cloudflare-provision.sh",
      "sudo /tmp/cloudflare-provision.sh"
    ]

  }
}

resource "proxmox_lxc" "cloudflare-tunnel-solufit-3" {
  hostname    = "solufit-cloudflare-tunnel-3"
  description = "cloudflare tunnel for Solufit"
  target_node = "milky-polaris"

  vmid = 2005

  clone = 9102

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
    bridge   = "evnet1"
    firewall = false
    ip       = "10.0.0.52/24"
  }
  network {
    name     = "eth1"
    bridge   = "vmbr2"
    firewall = false
    ip       = "dhcp"
    mtu      = 1400
  }

  provisioner "remote-exec" {
    connection {
      type        = "ssh"
      user        = "root"
      private_key = var.ssh_private_key
      host        = "10.0.0.52"
    }
    inline = [
      "apt-get update && apt-get upgrade -y && apt-get install -y curl",
      "echo '#! /bin/sh' > /tmp/cloudflare-provision.sh",
      "echo '${var.cloudflare_provision}' >> /tmp/cloudflare-provision.sh",
      "chmod +x /tmp/cloudflare-provision.sh",
      "sudo /tmp/cloudflare-provision.sh"
    ]

  }
}

resource "proxmox_lxc" "cloudflare-tunnel-solufit-4" {
  hostname    = "solufit-cloudflare-tunnel-4"
  description = "cloudflare tunnel for Solufit"
  target_node = "milky-carina"

  vmid = 2005

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
    bridge   = "evnet1"
    firewall = false
    ip       = "10.0.0.53/24"
  }
  network {
    name     = "eth1"
    bridge   = "vmbr2"
    firewall = false
    ip       = "dhcp"
    mtu      = 1400
  }

  network {
    name     = "eth2"
    bridge   = "vmbr1"
    firewall = false
    ip       = "172.16.0.69"
  }
  network {
    name     = "eth3"
    bridge   = "vmbr1"
    firewall = false
    ip       = "172.16.1.66/26"
    tag      = "4"
  }
  network {
    name     = "eth4"
    bridge   = "vmbr1"
    firewall = false
    ip       = "172.16.0.134/26"
    tag      = "20"
  }
  network {
    name     = "eth5"
    bridge   = "vmbr1"
    firewall = false
    ip       = "172.16.0.198/26"
    tag      = "21"
  }
  provisioner "remote-exec" {
    connection {
      type        = "ssh"
      user        = "root"
      private_key = var.ssh_private_key
      host        = "10.0.0.53"
    }
    inline = [
      "apt-get update && apt-get upgrade -y && apt-get install -y curl",
      "echo '#! /bin/sh' > /tmp/cloudflare-provision.sh",
      "echo '${var.cloudflare_provision_2}' >> /tmp/cloudflare-provision.sh",
      "chmod +x /tmp/cloudflare-provision.sh",
      "sudo /tmp/cloudflare-provision.sh"
    ]

  }
}