# Cloud Flare Tunnel Settings
/* Uses Cloud-Init options from Proxmox 5.2 */
/*
resource "proxmox_vm_qemu" "gateway-1" {
  name        = "ssh-gateway-1"
  desc        = "ssh-gateway"
  target_node = "milky-capella"


  clone = "ubuntu2204-withdocker"

  bootdisk = "scsi0"

  # The destination resource pool for the new VM
  pool = "solufit"

  cores   = 2
  sockets = 1
  memory  = 2048

  scsihw = "virtio-scsi-pci"

  os_type  = "cloud-init"
  ssh_user = "ubuntu"
  sshkeys  = var.ssh_public_key


  ipconfig0 = "ip=10.0.0.61/24"
  ipconfig1 = "ip=dhcp"
  ipconfig2 = "ip=10.100.0.2/24"

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
  network {
    model    = "virtio"
    bridge   = "k3s"
    firewall = false
    mtu      = 1400
  }

  disks {
    scsi {
      scsi0 {
        disk {
          size    = "32G"
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

  ssh_forward_ip  = "10.0.0.61"
  ssh_private_key = var.ssh_private_key

  provisioner "remote-exec" {
    connection {
      type        = "ssh"
      user        = self.ssh_user
      private_key = self.ssh_private_key
      host        = self.ssh_forward_ip
    }
    inline = [
      "sudo apt-get update && sudo apt-get install -y ssh-import-id curl",
      "ssh-import-id gh:walkmana-25",
      "ssh-import-id gh:sasanqua-dev",
      "curl -fsSL https://tailscale.com/install.sh | sh",
      "sudo adduser --disabled-password --comment \"\" yuuta",
      "sudo adduser --disabled-password --comment \"\" sasanqua",
      "sudo usermod -aG sudo yuuta",
      "sudo usermod -aG sudo sasanqua",
      "sudo -u yuuta bash -c 'ssh-import-id gh:walkmana-25'",
      "sudo -u sasanqua bash -c 'ssh-import-id gh:'sasanqua-dev",
      "sudo apt-get remove docker -y"
    ]

  }
}

resource "proxmox_vm_qemu" "workstation-1" {
  name        = "workstation-1"
  desc        = "workstation-1"
  target_node = "milky-polaris"

  clone = "ubuntu2204-withdocker"

  bootdisk = "scsi0"

  # The destination resource pool for the new VM
  pool    = "solufit"
  cores   = 8
  sockets = 1
  memory  = 16384

  scsihw = "virtio-scsi-pci"

  os_type  = "cloud-init"
  ssh_user = "ubuntu"
  sshkeys  = var.ssh_public_key


  ipconfig0 = "ip=10.0.0.62/24"
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
          size    = "64G"
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

  ssh_forward_ip  = "10.0.0.62"
  ssh_private_key = var.ssh_private_key

  provisioner "remote-exec" {
    connection {
      type        = "ssh"
      user        = self.ssh_user
      private_key = self.ssh_private_key
      host        = self.ssh_forward_ip
    }
    inline = [
      "sudo apt-get update && sudo apt-get install -y ssh-import-id curl build-essential golang-go rustup nodejs fish tmux zsh vim vim-nox git unzip",
      "curl -fsSL https://tailscale.com/install.sh | sh",
      "ssh-import-id gh:walkmana-25",
      "ssh-import-id gh:sasanqua-dev",
      "sudo adduser --disabled-password --comment \"\" yuuta",
      "sudo adduser --disabled-password --comment \"\" sasanqua",
      "sudo usermod -aG sudo yuuta",
      "sudo usermod -aG sudo sasanqua",
      "sudo -u yuuta bash -c 'ssh-import-id gh:walkmana-25'",
      "sudo -u sasanqua bash -c 'ssh-import-id gh:sasanqua-dev'",
      "sudo usermod -aG docker yuuta",
      "sudo usermod -aG docker sasanqua",
    ]

  }
}

*/
