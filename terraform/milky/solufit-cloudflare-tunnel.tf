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

  memory = 512
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

resource "proxmox_vm_qemu" "cloudflare-tunnel-solufit-2" {
  name        = "solufit-cloudflare-tunnel-2"
  desc        = "cloudflare tunnel for Solufit"
  target_node = "milky-polaris"
  vmid        = 2004

  automatic_reboot = true

  clone = "ubuntu2204-withdocker"

  bootdisk = "scsi0"

  # The destination resource pool for the new VM
  pool = "solufit"

  cores   = 3
  sockets = 1
  memory  = 4096

  scsihw = "virtio-scsi-pci"

  os_type  = "cloud-init"
  ssh_user = "ubuntu"
  sshkeys  = var.ssh_public_key


  ipconfig0 = "ip=10.0.0.51/24"
  ipconfig1 = "ip=dhcp"

  network {
    model    = "virtio"
    bridge   = "evnet1"
    firewall = false
    mtu      = 1400
  }
  network {
    model    = "virtio"
    bridge   = "vmbr2"
    firewall = false
  }

  disks {
    scsi {
      scsi0 {
        disk {
          size    = "10G"
          storage = "local-lvm"
        }
      }
    }
    ide {
      ide0 {
        cloudinit {
          storage = "local-lvm"
        }
      }
    }
  }

  ssh_forward_ip  = "10.0.0.51"
  ssh_private_key = var.ssh_private_key

  provisioner "remote-exec" {
    connection {
      type        = "ssh"
      user        = self.ssh_user
      private_key = self.ssh_private_key
      host        = self.ssh_forward_ip
    }
    inline = [
      "echo '#! /bin/sh' > /tmp/cloudflare-provision.sh",
      "echo '${var.cloudflare_provision}' >> /tmp/cloudflare-provision.sh",
      "chmod +x /tmp/cloudflare-provision.sh",
      "sudo /tmp/cloudflare-provision.sh"
    ]

  }
}


resource "proxmox_vm_qemu" "cloudflare-tunnel-solufit-3" {
  name        = "solufit-cloudflare-tunnel-3"
  desc        = "cloudflare tunnel for Solufit"
  target_node = "milky-carina"
  vmid        = 2005

  clone = "ubuntu2204-withdocker"

  automatic_reboot = true

  bootdisk = "scsi0"

  # The destination resource pool for the new VM
  pool = "solufit"

  cores   = 3
  sockets = 1
  memory  = 4096

  scsihw = "virtio-scsi-pci"

  os_type  = "cloud-init"
  ssh_user = "ubuntu"
  sshkeys  = var.ssh_public_key


  ipconfig0 = "ip=10.0.0.52/24"
  ipconfig1 = "ip=dhcp"

  network {
    model    = "virtio"
    bridge   = "evnet1"
    firewall = false
    mtu      = 1400
  }
  network {
    model    = "virtio"
    bridge   = "vmbr2"
    firewall = false
  }

  disks {
    scsi {
      scsi0 {
        disk {
          size    = "10G"
          storage = "local-lvm"
        }
      }
    }
    ide {
      ide0 {
        cloudinit {
          storage = "local-lvm"
        }
      }
    }
  }

  ssh_forward_ip  = "10.0.0.52"
  ssh_private_key = var.ssh_private_key

  provisioner "remote-exec" {
    connection {
      type        = "ssh"
      user        = self.ssh_user
      private_key = self.ssh_private_key
      host        = self.ssh_forward_ip
    }
    inline = [
      "echo '#! /bin/sh' > /tmp/cloudflare-provision.sh",
      "echo '${var.cloudflare_provision}' >> /tmp/cloudflare-provision.sh",
      "chmod +x /tmp/cloudflare-provision.sh",
      "sudo /tmp/cloudflare-provision.sh"
    ]

  }
}

resource "proxmox_vm_qemu" "cloudflare-tunnel-solufit-4" {
  name        = "solufit-cloudflare-tunnel-4"
  desc        = "cloudflare tunnel for Solufit"
  target_node = "milky-carina"
  vmid        = 2006

  clone = "ubuntu2204-withdocker"

  automatic_reboot = true

  bootdisk = "scsi0"

  # The destination resource pool for the new VM
  pool = "solufit"

  cores   = 3
  sockets = 1
  memory  = 4096

  scsihw = "virtio-scsi-pci"

  os_type  = "cloud-init"
  ssh_user = "ubuntu"
  sshkeys  = var.ssh_public_key


  ipconfig0 = "ip=10.0.0.53/24"
  ipconfig1 = "ip=172.16.0.69/26"
  ipconfig2 = "ip=dhcp"
  ipconfig3 = "ip=172.16.1.66/26"
  ipconfig4 = "ip=172.16.0.134/26"
  ipconfig5 = "ip=172.16.0.198/26"

  network {
    model    = "virtio"
    bridge   = "evnet1"
    firewall = false
    mtu      = 1400
  }
  network {
    model    = "virtio"
    bridge   = "vmbr1"
    firewall = false
    mtu      = 1400
    tag      = 1
  }
  network {
    model    = "virtio"
    bridge   = "vmbr2"
    firewall = false
  }
  network {
    model    = "virtio"
    bridge   = "vmbr1"
    firewall = false
    mtu      = 1400
    tag      = 4
  }
  network {
    model    = "virtio"
    bridge   = "vmbr1"
    firewall = false
    mtu      = 1400
    tag      = 20
  }
  network {
    model    = "virtio"
    bridge   = "vmbr1"
    firewall = false
    mtu      = 1400
    tag      = 21
  }

  disks {
    scsi {
      scsi0 {
        disk {
          size    = "10G"
          storage = "local-lvm"
        }
      }
    }
    ide {
      ide0 {
        cloudinit {
          storage = "local-lvm"
        }
      }
    }
  }

  ssh_forward_ip  = "10.0.0.53"
  ssh_private_key = var.ssh_private_key

  provisioner "remote-exec" {
    connection {
      type        = "ssh"
      user        = self.ssh_user
      private_key = self.ssh_private_key
      host        = self.ssh_forward_ip
    }
    inline = [
      "ssh-import-id gh:walkmana-25",
      "echo '#! /bin/sh' > /tmp/cloudflare-provision.sh",
      "echo '${var.cloudflare_provision_2}' >> /tmp/cloudflare-provision.sh",
      "chmod +x /tmp/cloudflare-provision.sh",
      "sudo /tmp/cloudflare-provision.sh"
    ]

  }
}