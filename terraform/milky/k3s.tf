# システム監視用のKubernetesクラスタ
variable "ssh_public_key_k3s" {
  description = "The public key to use for SSH access"
}
variable "ssh_private_key_k3s" {
  description = "The private key to use for SSH access"
}

resource "proxmox_vm_qemu" "k3s-ansible-host" {
  name        = "k3s-ansible-host"
  desc        = "Management Kubernetes cluster for Solufit"
  target_node = "milky-capella"


  clone = "ubuntu2204-withdocker"

  bootdisk = "virtio0"

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
    model    = "virtio"
    bridge   = "k3s"
    firewall = false
  }
  network {
    model    = "virtio"
    bridge   = "vmbr2"
    firewall = true
  }

  disks {
    virtio {
      virtio0 {
        disk {
          size    = "16G"
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

  ssh_forward_ip  = "10.100.0.5"
  ssh_private_key = var.ssh_private_key

  cicustom = <<EOF
#cloud-config
package_update: true
package_upgrade: true
packages:
  - python3
  - python3-pip
  - python3-venv
  - ansible-core
  - ansible-lint
  - ansible-mitogen
  - git

users:
  - name: ubuntu
    sudo: ALL=(ALL) NOPASSWD:ALL
    groups: sudo
    shell: /bin/bash
    ssh_authorized_keys:
      - ${var.ssh_public_key_k3s}
      - ${var.ssh_public_key}
    ssh_import_id:
      - gh:walkmana-25
      - gh:sasanqua-dev


write_files:
  - content: |
      ${var.ssh_private_key_k3s}
    path: /home/ubuntu/.ssh/id_rsa
    permissions: '0600'
    owner: ubuntu:ubuntu

EOF


}

resource "proxmox_vm_qemu" "k3s-controller-1" {
  name        = "solufit-k3s-controller-1"
  desc        = "Management Kubernetes cluster for Solufit"
  target_node = "milky-capella"


  clone = "ubuntu2204-withdocker"

  bootdisk = "virtio0"

  # The destination resource pool for the new VM
  pool = "solufit"

  cores   = 4
  sockets = 1
  memory  = 4096

  scsihw = "virtio-scsi-pci"

  os_type  = "cloud-init"
  ssh_user = "ubuntu"
  sshkeys  = var.ssh_public_key


  ipconfig0 = "ip=10.100.0.10/24"
  ipconfig1 = "ip=dhcp"

  network {
    model    = "virtio"
    bridge   = "k3s"
    firewall = false
  }
  network {
    model    = "virtio"
    bridge   = "vmbr2"
    firewall = true
  }

  disks {
    virtio {
      virtio0 {
        disk {
          size    = "32G"
          storage = "local-lvm"
        }
      }
      virtio1 {
        disk {
          size    = "128G"
          storage = "main"
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

  ssh_forward_ip  = "10.100.0.10"
  ssh_private_key = var.ssh_private_key

}

resource "proxmox_vm_qemu" "k3s-worker-1" {
  name        = "solufit-k3s-worker-1"
  desc        = "Management Kubernetes cluster for Solufit"
  target_node = "milky-polaris"


  clone = "ubuntu2204-withdocker"

  bootdisk = "virtio0"

  # The destination resource pool for the new VM
  pool = "solufit"

  cores   = 4
  sockets = 1
  memory  = 4096

  scsihw = "virtio-scsi-pci"

  os_type  = "cloud-init"
  ssh_user = "ubuntu"
  sshkeys  = var.ssh_public_key


  ipconfig0 = "ip=10.100.0.20/24"
  ipconfig1 = "ip=dhcp"

  network {
    model    = "virtio"
    bridge   = "k3s"
    firewall = false
  }
  network {
    model    = "virtio"
    bridge   = "vmbr2"
    firewall = true
  }

  disks {
    virtio {
      virtio0 {
        disk {
          size    = "32G"
          storage = "local-lvm"
        }
      }
      virtio1 {
        disk {
          size    = "128G"
          storage = "main"
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

  ssh_forward_ip  = "10.100.0.20"
  ssh_private_key = var.ssh_private_key

}
