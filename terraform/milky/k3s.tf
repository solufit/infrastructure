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

# ansible-host custom cloud config
resource "local_file" "k3s_ansible_host_cloud_config" {
  content = <<EOF
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
  - curl



write_files:
  - encoding: base64
    content: ${local.ssh_private_key_base64_k3s}
    path: /home/ubuntu/.ssh/id_rsa
    permissions: '0600'
    owner: ubuntu:ubuntu

runcmd:
  - [su, ubuntu, -c, 'ssh-import-id gh:walkmana-25']
  - [date]
  - [su, ubuntu, -c, 'curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"']
  - [su, ubuntu, -c, 'curl -s https://fluxcd.io/install.sh | sudo bash']
  - [su, ubuntu, -c, 'curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash']

  EOF

  filename = "${path.module}/files/ansible-host-cloud-config.yaml"
}

resource "null_resource" "always_run" {
  triggers = {
    always_run = "${timestamp()}"
  }
}

resource "null_resource" "k3s_ansible_host_cloud_config_ssh_file_provisioner" {
  connection {
    type     = "ssh"
    host     = var.pve_ssh_node
    user     = var.pve_ssh_user
    password = var.pve_ssh_password
  }
  depends_on = [local_file.k3s_ansible_host_cloud_config]
  provisioner "file" {
    source      = local_file.k3s_ansible_host_cloud_config.filename
    destination = "${var.snnipet_root}ansible-host-cloud-config.yaml"
  }
  lifecycle {
    create_before_destroy = true
    replace_triggered_by  = [null_resource.always_run]
  }
}

resource "proxmox_vm_qemu" "k3s-manager-ansible-host" {
  depends_on = [
    null_resource.k3s_ansible_host_cloud_config_ssh_file_provisioner
  ]
  name        = "k3s-ansible-host"
  desc        = "Management Kubernetes cluster for Solufit"
  target_node = "milky-capella"
  vmid        = 1000


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
    model    = "virtio"
    bridge   = "k3s"
    firewall = false
    mtu      = 1400

  }
  network {
    model    = "virtio"
    bridge   = "vmbr2"
    firewall = true
  }

  disks {
    scsi {
      scsi0 {
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

  cicustom = "vendor=cephfs:snippets/ansible-host-cloud-config.yaml"



}

resource "proxmox_vm_qemu" "k3s-manager-controller-1" {
  name        = "solufit-k3s-controller-1"
  desc        = "Management Kubernetes cluster for Solufit"
  target_node = "milky-capella"

  vmid = 10000


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


  ipconfig0 = "ip=10.100.0.10/24"
  ipconfig1 = "ip=dhcp"

  network {
    model    = "virtio"
    bridge   = "k3s"
    firewall = false
    mtu      = 1400

  }
  network {
    model    = "virtio"
    bridge   = "vmbr2"
    firewall = false
  }

  disks {
    virtio {
      virtio0 {
        disk {
          size    = "128G"
          storage = "main"
        }
      }
    }
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


  ipconfig0 = "ip=10.100.0.11/24"
  ipconfig1 = "ip=dhcp"

  network {
    model    = "virtio"
    bridge   = "k3s"
    firewall = false
    mtu      = 1400

  }
  network {
    model    = "virtio"
    bridge   = "vmbr2"
    firewall = false
  }

  disks {
    virtio {
      virtio0 {
        disk {
          size    = "128G"
          storage = "main"
        }
      }
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


  ipconfig0 = "ip=10.100.0.12/24"
  ipconfig1 = "ip=dhcp"

  network {
    model    = "virtio"
    bridge   = "k3s"
    firewall = false
    mtu      = 1400

  }
  network {
    model    = "virtio"
    bridge   = "vmbr2"
    firewall = false
  }

  disks {
    virtio {
      virtio0 {
        disk {
          size    = "128G"
          storage = "main"
        }
      }
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

  ssh_forward_ip = "10.100.0.12"

  sshkeys = <<EOF
${var.ssh_public_key}
${var.ssh_public_key_k3s}

EOF



}



resource "proxmox_vm_qemu" "k3s-manager-worker-1" {
  name        = "solufit-k3s-worker-1"
  desc        = "Management Kubernetes cluster for Solufit"
  target_node = "milky-capella"
  vmid        = 11000


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
    model    = "virtio"
    bridge   = "k3s"
    firewall = false
    mtu      = 1400
  }
  network {
    model    = "virtio"
    bridge   = "vmbr2"
    firewall = false
  }

  disks {
    virtio {
      virtio0 {
        disk {
          size    = "128G"
          storage = "main"
        }
      }
    }
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


  ipconfig0 = "ip=10.100.0.21/24"
  ipconfig1 = "ip=dhcp"

  network {
    model    = "virtio"
    bridge   = "k3s"
    firewall = false
    mtu      = 1400
  }
  network {
    model    = "virtio"
    bridge   = "vmbr2"
    firewall = false
  }

  disks {
    virtio {
      virtio0 {
        disk {
          size    = "128G"
          storage = "main"
        }
      }
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


  ipconfig0 = "ip=10.100.0.22/24"
  ipconfig1 = "ip=dhcp"

  network {
    model    = "virtio"
    bridge   = "k3s"
    firewall = false
    mtu      = 1400
  }
  network {
    model    = "virtio"
    bridge   = "vmbr2"
    firewall = false
  }

  disks {
    virtio {
      virtio0 {
        disk {
          size    = "128G"
          storage = "main"
        }
      }
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

  ssh_forward_ip = "10.100.0.22"

  sshkeys = <<EOF
${var.ssh_public_key}
${var.ssh_public_key_k3s}

EOF

}