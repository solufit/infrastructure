# Cloud Flare Tunnel Settings
/* Uses Cloud-Init options from Proxmox 5.2 */
resource "proxmox_vm_qemu" "cloudflare-tunnel" {
  name        = "cloudflare-tunnel"
  desc        = "cloudflare"
  target_node = "milky-capella"

  clone = "ubuntu2204-withdocker"

  # The destination resource pool for the new VM
  pool = "solufit"

  cores   = 3
  sockets = 1
  memory  = 4096


  os_type   = "cloud-init"
  ipconfig0 = "ip=10.0.0.50/24,gw=10.0.0.1"



}

