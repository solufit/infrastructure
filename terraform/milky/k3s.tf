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

users:
  - name: ubuntu
    sudo: ALL=(ALL) NOPASSWD:ALL
    groups: sudo
    shell: /bin/bash
    ssh_pwauth: no
    passwd: $6$rounds=4096$ih7uYkBNGE/Jfc5E$WIuiTyWL/gtYm1P6BrHnxRho9v62NJKTc3pd/15J/IhlCrra4r1Mpnrzm6dXkkSygTSM0qjQuPzKeCoIJfFbT0
    lock_passwd: false
    ssh_authorized_keys:
      - ${var.ssh_public_key_k3s}
      - ${var.ssh_public_key}
    ssh_import_id:
      - gh:walkmana-25
      - gh:sasanqua-dev


write_files:
  - encoding: base64
    content: ${local.ssh_private_key_base64_k3s}
    path: /home/ubuntu/.ssh/id_rsa
    permissions: '0600'
    owner: ubuntu:ubuntu

  EOF

  filename = "${path.module}/files/ansible-host-cloud-config.yaml"
}

resource "null_resource" "k3s_ansible_host_cloud_config_provisioner" {
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
}

resource "proxmox_vm_qemu" "k3s-manager-ansible-host" {
  depends_on = [
    null_resource.k3s_ansible_host_cloud_config_provisioner
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

resource "proxmox_vm_qemu" "k3s-manager-controller-01" {
  name        = "solufit-k3s-controller-01"
  desc        = "Management Kubernetes cluster for Solufit"
  target_node = "milky-capella"

  vmid = 1001


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

resource "proxmox_vm_qemu" "k3s-manager-worker-01" {
  name        = "solufit-k3s-worker-01"
  desc        = "Management Kubernetes cluster for Solufit"
  target_node = "milky-polaris"
  vmid        = 1002


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

  ssh_forward_ip = "10.100.0.20"

  sshkeys = <<EOF
${var.ssh_public_key}
${var.ssh_public_key_k3s}

EOF

}
