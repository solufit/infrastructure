#resource "proxmox_lxc" "k3s-lb-1" {
#  hostname    = "solufit-k3s-lb-1"
#  description = "cloudflare tunnel for Solufit"
#  target_node = "milky-capella"
#
#  vmid = 12001
#
#  clone = 9100
#
#  start = true
#
#  rootfs {
#    storage = "main-storage"
#    size    = "8G"
#  }
#  # The destination resource pool for the new VM
#  pool = "solufit"
#
#  memory = 256
#  cores  = 1
#
#  onboot = true
#
#
#  network {
#    name     = "eth0"
#    bridge   = "k3s"
#    firewall = false
#    ip       = "10.100.0.6/24"
#  }
#  network {
#    name     = "eth1"
#    bridge   = "vmbr2"
#    firewall = false
#    ip       = "dhcp"
#    mtu      = 1400
#  }
#
#  provisioner "remote-exec" {
#    connection {
#      type        = "ssh"
#      user        = "root"
#      private_key = var.ssh_private_key
#      host        = "10.100.0.6"
#    }
#    inline = [
#      "mkdir -p /root/.ssh",
#      "echo '${var.ssh_public_key_k3s}' >> /root/.ssh/authorized_keys",
#      "chmod 700 /root/.ssh && chmod 600 /root/.ssh/authorized_keys"
#    ]
#
#  }
#}
#
#


resource "proxmox_lxc" "k3s-lb-2" {
  hostname    = "solufit-k3s-lb-2"
  description = "cloudflare tunnel for Solufit"
  target_node = "milky-carina"

  vmid = 12002

  clone = 9101

  start = true
  rootfs {
    storage = "main-storage"
    size    = "8G"
  }

  # The destination resource pool for the new VM
  pool = "solufit"

  memory = 256
  cores  = 1

  onboot = true


  network {
    name     = "eth0"
    bridge   = "k3s"
    firewall = false
    ip       = "10.100.0.7/24"
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
      host        = "10.100.0.7"
    }
    inline = [
      "mkdir -p /root/.ssh",
      "echo '${var.ssh_public_key_k3s}' >> /root/.ssh/authorized_keys",
      "chmod 700 /root/.ssh && chmod 600 /root/.ssh/authorized_keys"
    ]

  }
}


resource "proxmox_lxc" "k3s-lb-3" {
  hostname    = "solufit-k3s-lb-3"
  description = "cloudflare tunnel for Solufit"
  target_node = "milky-polaris"

  vmid = 12003

  clone = 9102

  start = true
  rootfs {
    storage = "main-storage"
    size    = "8G"
  }

  # The destination resource pool for the new VM
  pool = "solufit"

  memory = 256
  cores  = 1

  onboot = true


  network {
    name     = "eth0"
    bridge   = "k3s"
    firewall = false
    ip       = "10.100.0.8/24"
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
      host        = "10.100.0.8"
    }
    inline = [
      "mkdir -p /root/.ssh",
      "echo '${var.ssh_public_key_k3s}' >> /root/.ssh/authorized_keys",
      "chmod 700 /root/.ssh && chmod 600 /root/.ssh/authorized_keys"
    ]

  }
}

resource "proxmox_vm_qemu" "k3s-nfs" {
  name        = "solufit-k3s-nfs"
  desc        = "Management Kubernetes cluster for Solufit"
  target_node = "milky-polaris"

  vmid = 12004

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


  ipconfig0 = "ip=10.100.0.9/24"
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
          size    = "10G"
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
    virtio {
      virtio0 {
        disk {
          size    = "200G"
          storage = "main-storage"
        }
      }
    }
  }

  ssh_forward_ip = "10.100.0.9"

  sshkeys = <<EOF
${var.ssh_public_key}
${var.ssh_public_key_k3s}

EOF



}