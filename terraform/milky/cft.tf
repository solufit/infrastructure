# Cloud Flare Tunnel Settings
/* Uses Cloud-Init options from Proxmox 5.2 */
variable "cloudflare_provision" {
  type = string
}

resource "proxmox_vm_qemu" "cloudflare-tunnel" {
  name        = "cloudflare-tunnel"
  desc        = "cloudflare"
  target_node = "milky-capella"

  vmid = 203

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


  ipconfig0 = "ip=10.0.0.50/24,gw=10.0.0.1"

  network {
    model    = "virtio"
    bridge   = "evnet1"
    firewall = false
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
          size    = "20G"
          storage = "main"
        }
      }
    }
    ide {
      ide0 {
        cloudinit {
          storage = "main"
        }
      }
    }
  }

  ssh_forward_ip  = "10.0.0.50"
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

