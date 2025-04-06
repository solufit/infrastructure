

locals {
  ssh_private_key_base64_k8s_a = sensitive("${base64encode(var.ssh_private_keys_k3s)}")
}

# 管理用ホスト
resource "proxmox_vm_qemu" "k8s-a-ansible-host" {
  name        = "k8s-a-ansible-host"
  desc        = "Kubernetes A Cluster Management Host"
  target_node = "milky-carina"
  vmid        = 40000

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
  sshkeys  = var.ssh_public_keys_k3s

  # Add serial port
  serial {
    id   = 0
    type = "socket"
  }

  ipconfig0 = "ip=10.0.10.50/24"
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
          storage = "main-storage"
        }
      }
    }
  }

  ssh_forward_ip  = "10.0.10.50"
  ssh_private_key = var.ssh_private_keys_k3s

  provisioner "remote-exec" {
    connection {
      type        = "ssh"
      user        = self.ssh_user
      private_key = self.ssh_private_keys_k3s
      host        = self.ssh_forward_ip
    }
    inline = [
      "ssh-import-id gh:walkmana-25",
      "wget 'https://fluxcd.io/install.sh'",
      "sudo bash install.sh",
      "rm install.sh",
      "sudo snap install kubectl --classic",
      "sudo snap install helm --classic",
      "echo ${local.ssh_private_key_base64_k8s_a} | base64 -d > ~/.ssh/id_rsa",
      "chmod 600 ~/.ssh/id_rsa"
    ]
  }
}

# コントローラーノード
resource "proxmox_vm_qemu" "k8s-a-controller-1" {
  name        = "k8s-a-controller-1"
  desc        = "Kubernetes A Cluster Controller Node"
  target_node = "milky-carina"
  vmid        = 40100

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

  # Add serial port
  serial {
    id   = 0
    type = "socket"
  }

  ipconfig0 = "ip=10.0.10.51/24"
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
          storage = "main-storage"
        }
      }
    }
    ide {
      ide0 {
        cloudinit {
          storage = "main-storage"
        }
      }
    }
  }

  ssh_forward_ip = "10.0.10.51"

  sshkeys = <<EOF
${var.ssh_public_key}
${var.ssh_public_keys_k3s}
EOF
}

# ワーカーノード
resource "proxmox_vm_qemu" "k8s-a-worker-1" {
  name        = "k8s-a-worker-1"
  desc        = "Kubernetes A Cluster Worker Node"
  target_node = "milky-polaris"
  vmid        = 40200

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

  # Add serial port
  serial {
    id   = 0
    type = "socket"
  }

  ipconfig0 = "ip=10.0.10.61/24"
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
          storage = "main-storage"
        }
      }
    }
    ide {
      ide0 {
        cloudinit {
          storage = "main-storage"
        }
      }
    }
  }

  ssh_forward_ip = "10.0.10.61"

  sshkeys = <<EOF
${var.ssh_public_key}
${var.ssh_public_keys_k3s}
EOF
}