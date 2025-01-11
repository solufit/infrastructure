
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