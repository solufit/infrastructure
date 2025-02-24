resource "proxmox_vm_qemu" "k8s-play-manager-ansible-host" {
  name        = "k8s-play-ansible-host"
  desc        = "Kubernetes playground for Solufit"
  target_node = "milky-carina"
  vmid        = 30000

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


  ipconfig0 = "ip=10.100.2.3/24"
  ipconfig1 = "ip=dhcp"

  network {
    id       = 0
    model    = "virtio"
    bridge   = "k8splay"
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

  ssh_forward_ip  = "10.100.2.3"
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

resource "proxmox_vm_qemu" "k8s-play-controller" {
  name        = "solufit-k8s-playground-controller"
  desc        = "Playground Kubernetes cluster for Solufit"
  target_node = "milky-polaris"

  vmid = 31000

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


  ipconfig0 = "ip=10.100.2.10/24"
  ipconfig1 = "ip=dhcp"

  network {
    id       = 0
    model    = "virtio"
    bridge   = "k8splay"
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
          storage = "local-lvm"
        }
      }
    }
  }

  ssh_forward_ip = "10.100.2.10"

  sshkeys = <<EOF
${var.ssh_public_key}
${var.ssh_public_key_k3s}

EOF



}




resource "proxmox_vm_qemu" "k8s-play-worker" {
  name        = "solufit-k8s-playground-worker"
  desc        = "Playground Kubernetes cluster for Solufit"
  target_node = "milky-polaris"
  vmid        = 32000

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


  ipconfig0 = "ip=10.100.2.20/24"
  ipconfig1 = "ip=dhcp"

  network {
    id       = 0
    model    = "virtio"
    bridge   = "k8splay"
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
          storage = "local-lvm"
        }
      }
    }
  }

  ssh_forward_ip = "10.100.2.20"

  sshkeys = <<EOF
${var.ssh_public_key}
${var.ssh_public_key_k3s}

EOF

}