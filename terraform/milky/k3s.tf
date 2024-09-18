# システム監視用のKubernetesクラスタ


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