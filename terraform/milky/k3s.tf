# システム監視用のKubernetesクラスタ
variable "ssh_public_key_k3s" {
  description = "The public key to use for SSH access"
}
variable "ssh_private_key_k3s" {
  description = "The private key to use for SSH access"
  sensitive   = true
}

locals {
  ssh_private_key_base64_k3s = sensitive("${base64encode(var.ssh_private_key_k3s)}")
}



resource "proxmox_vm_qemu" "k3s-manager-ansible-host" {
  name        = "k3s-ansible-host"
  desc        = "Management Kubernetes cluster for Solufit"
  target_node = "milky-carina"
  vmid        = 1000

  agent = 1


  clone = "ubuntu2204-withdocker"

  bootdisk = "scsi0"
  boot     = "order=scsi0"

  # The destination resource pool for the new VM
  pool = "solufit"

  cores   = 2
  sockets = 1
  memory  = 2048

  scsihw = "virtio-scsi-pci"

  os_type  = "cloud-init"
  ssh_user = "ubuntu"
  sshkeys  = var.ssh_public_key


  ipconfig0 = "ip=10.100.0.5/24"
  ipconfig1 = "ip=dhcp"

  network {
    id       = 0
    model    = "virtio"
    bridge   = "k3s"
    firewall = false
    mtu      = 1400

  }
  network {
    id       = 1
    model    = "virtio"
    bridge   = "vmbr2"
    firewall = true
  }

  disks {
    scsi {
      scsi0 {
        disk {
          size    = "16G"
          storage = "main-storage"
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

  ssh_forward_ip  = "10.100.0.5"
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
      "wget 'https://fluxcd.io/install.sh'",
      "sudo bash install.sh",
      "rm install.sh",
      "sudo snap install kubectl --classic",
      "sudo snap install helm --classic",
      "echo ${local.ssh_private_key_base64_k3s} | base64 -d > ~/.ssh/id_rsa",
      "chmod 600 ~/.ssh/id_rsa"
    ]

  }

}

resource "proxmox_vm_qemu" "k3s-manager-controller-1" {
  name        = "solufit-k3s-controller-1"
  desc        = "Management Kubernetes cluster for Solufit"
  target_node = "milky-carina"

  vmid = 10000

  agent = 1



  clone = "ubuntu2204-withdocker"

  bootdisk = "scsi0"
  boot     = "order=scsi0"

  # The destination resource pool for the new VM
  pool = "solufit"

  cores   = 4
  sockets = 1
  memory  = 8192

  scsihw = "virtio-scsi-pci"

  os_type  = "cloud-init"
  ssh_user = "ubuntu"


  ipconfig0 = "ip=10.100.0.10/24"
  ipconfig1 = "ip=dhcp"

  network {
    id       = 0
    model    = "virtio"
    bridge   = "k3s"
    firewall = false
    mtu      = 1400

  }
  network {
    id       = 1
    model    = "virtio"
    bridge   = "vmbr2"
    firewall = false
  }

  disks {
    scsi {
      scsi0 {
        disk {
          size    = "32G"
          storage = "data"
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

  ssh_forward_ip = "10.100.0.10"

  sshkeys = <<EOF
${var.ssh_public_key}
${var.ssh_public_key_k3s}

EOF



}

resource "proxmox_vm_qemu" "k3s-manager-controller-2" {
  name        = "solufit-k3s-controller-2"
  desc        = "Management Kubernetes cluster for Solufit"
  target_node = "milky-carina"

  vmid = 10001

  agent = 1


  clone = "ubuntu2204-withdocker"

  bootdisk = "scsi0"
  boot     = "order=scsi0"

  # The destination resource pool for the new VM
  pool = "solufit"

  cores   = 4
  sockets = 1
  memory  = 8192

  scsihw = "virtio-scsi-pci"

  os_type  = "cloud-init"
  ssh_user = "ubuntu"


  ipconfig0 = "ip=10.100.0.11/24"
  ipconfig1 = "ip=dhcp"

  network {
    id       = 0
    model    = "virtio"
    bridge   = "k3s"
    firewall = false
    mtu      = 1400

  }
  network {
    id       = 1
    model    = "virtio"
    bridge   = "vmbr2"
    firewall = false
  }

  disks {
    scsi {
      scsi0 {
        disk {
          size    = "32G"
          storage = "data"
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

  ssh_forward_ip = "10.100.0.11"

  sshkeys = <<EOF
${var.ssh_public_key}
${var.ssh_public_key_k3s}

EOF



}
resource "proxmox_vm_qemu" "k3s-manager-controller-3" {
  name        = "solufit-k3s-controller-3"
  desc        = "Management Kubernetes cluster for Solufit"
  target_node = "milky-polaris"

  vmid = 10002

  agent = 1


  clone = "ubuntu2204-withdocker"

  bootdisk = "scsi0"
  boot     = "order=scsi0"

  # The destination resource pool for the new VM
  pool = "solufit"

  cores   = 4
  sockets = 1
  memory  = 8192

  scsihw = "virtio-scsi-pci"

  os_type  = "cloud-init"
  ssh_user = "ubuntu"


  ipconfig0 = "ip=10.100.0.12/24"
  ipconfig1 = "ip=dhcp"

  network {

    id       = 0
    model    = "virtio"
    bridge   = "k3s"
    firewall = false
    mtu      = 1400

  }
  network {
    id       = 1
    model    = "virtio"
    bridge   = "vmbr2"
    firewall = false
  }

  disks {
    scsi {
      scsi0 {
        disk {
          size    = "32G"
          storage = "data"
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

  ssh_forward_ip = "10.100.0.12"

  sshkeys = <<EOF
${var.ssh_public_key}
${var.ssh_public_key_k3s}

EOF



}



resource "proxmox_vm_qemu" "k3s-manager-worker-1" {
  name        = "solufit-k3s-worker-1"
  desc        = "Management Kubernetes cluster for Solufit"
  target_node = "milky-carina"
  vmid        = 11000

  agent = 1


  clone = "ubuntu2204-withdocker"

  bootdisk = "scsi0"
  boot     = "order=scsi0"

  # The destination resource pool for the new VM
  pool = "solufit"

  cores   = 4
  sockets = 1
  memory  = 4096

  scsihw = "virtio-scsi-pci"

  os_type  = "cloud-init"
  ssh_user = "ubuntu"


  ipconfig0 = "ip=10.100.0.20/24"
  ipconfig1 = "ip=dhcp"

  network {
    id       = 0
    model    = "virtio"
    bridge   = "k3s"
    firewall = false
    mtu      = 1400
  }
  network {
    id       = 1
    model    = "virtio"
    bridge   = "vmbr2"
    firewall = false
  }

  disks {
    scsi {
      scsi0 {
        disk {
          size    = "32G"
          storage = "data"
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

  ssh_forward_ip = "10.100.0.20"

  sshkeys = <<EOF
${var.ssh_public_key}
${var.ssh_public_key_k3s}

EOF

}
resource "proxmox_vm_qemu" "k3s-manager-worker-2" {
  name        = "solufit-k3s-worker-2"
  desc        = "Management Kubernetes cluster for Solufit"
  target_node = "milky-polaris"
  vmid        = 11001

  agent = 1


  clone = "ubuntu2204-withdocker"

  bootdisk = "scsi0"
  boot     = "order=scsi0"

  # The destination resource pool for the new VM
  pool = "solufit"

  cores   = 2
  sockets = 1
  memory  = 4096

  scsihw = "virtio-scsi-pci"

  os_type  = "cloud-init"
  ssh_user = "ubuntu"


  ipconfig0 = "ip=10.100.0.21/24"
  ipconfig1 = "ip=dhcp"

  network {
    id       = 0
    model    = "virtio"
    bridge   = "k3s"
    firewall = false
    mtu      = 1400
  }
  network {
    id       = 1
    model    = "virtio"
    bridge   = "vmbr2"
    firewall = false
  }

  disks {
    virtio {
    }
    scsi {
      scsi0 {
        disk {
          size    = "32G"
          storage = "data"
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

  ssh_forward_ip = "10.100.0.21"

  sshkeys = <<EOF
${var.ssh_public_key}
${var.ssh_public_key_k3s}

EOF

}
resource "proxmox_vm_qemu" "k3s-manager-worker-3" {
  name        = "solufit-k3s-worker-3"
  desc        = "Management Kubernetes cluster for Solufit"
  target_node = "milky-carina"
  vmid        = 11002

  agent = 1


  clone = "ubuntu2204-withdocker"

  bootdisk = "scsi0"
  boot     = "order=scsi0"

  # The destination resource pool for the new VM
  pool = "solufit"

  cores   = 2
  sockets = 1
  memory  = 4096

  scsihw = "virtio-scsi-pci"

  os_type  = "cloud-init"
  ssh_user = "ubuntu"


  ipconfig0 = "ip=10.100.0.22/24"
  ipconfig1 = "ip=dhcp"

  network {
    id       = 0
    model    = "virtio"
    bridge   = "k3s"
    firewall = false
    mtu      = 1400
  }
  network {
    id       = 1
    model    = "virtio"
    bridge   = "vmbr2"
    firewall = false
  }

  disks {
    scsi {
      scsi0 {
        disk {
          size    = "32G"
          storage = "data"
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

  ssh_forward_ip = "10.100.0.22"

  sshkeys = <<EOF
${var.ssh_public_key}
${var.ssh_public_key_k3s}

EOF

}