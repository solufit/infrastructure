# システム監視用のKubernetesクラスタ

module "k3s-controller-1" {
  source = "./module/proxmox_vm"
  vmid   = 501

  vm_description = "K3s Controller Node"

  vm_name     = "k3s-controll-1"
  target_node = "milky-polaris"

  resource_pool = "solufit"

  template_name = "ubuntu2204-withdocker"

  cpu_cores         = "4"
  cpu_sockets       = "1"
  memory            = "8192"
  cloudinit_storage = "local-lvm"

  disks = [
    {
      size         = 32
      storage      = "local-lvm"
      storage_type = "lvm"
    },
    {
      size         = 128
      storage      = "local-lvm"
      storage_type = "lvm"
    },
  ]

  network_adapters = [
    {
      model    = "virtio"
      bridge   = "vmbr2"
      firewall = true
    },
    {
      model    = "virtio"
      bridge   = "k3s"
      firewall = true
    }
  ]
  boot_order = "order=virtio0;"
  ssh_keys   = var.ssh_public_key
  ipconfig = [
    "ip=dhcp",
    "ip=10.100.0.3/24"
  ]

}
module "k3s-worker-1" {
  source = "./module/proxmox_vm"
  vmid   = 502

  vm_description = "K3s worker Node"

  vm_name     = "k3s-controll-1"
  target_node = "milky-carina"

  resource_pool = "solufit"

  template_name = "ubuntu2204-withdocker"

  cpu_cores         = "4"
  cpu_sockets       = "1"
  memory            = "8192"
  cloudinit_storage = "local-lvm"

  disks = [
    {
      size         = 32
      storage      = "local-lvm"
      storage_type = "lvm"
    },
    {
      size         = 128
      storage      = "local-lvm"
      storage_type = "lvm"
    },
  ]

  network_adapters = [
    {
      model    = "virtio"
      bridge   = "vmbr2"
      firewall = true
    },
    {
      model    = "virtio"
      bridge   = "k3s"
      firewall = true
    }
  ]
  boot_order = "order=virtio0;"
  ssh_keys   = var.ssh_public_key
  ipconfig = [
    "ip=dhcp",
    "ip=10.100.0.4/24"
  ]

}
module "k3s-worker-2" {
  source = "./module/proxmox_vm"
  vmid   = 503

  vm_description = "K3s worker Node"

  vm_name     = "k3s-worker-2"
  target_node = "milky-capella"

  resource_pool = "solufit"

  template_name = "ubuntu2204-withdocker"

  cpu_cores         = "4"
  cpu_sockets       = "1"
  memory            = "8192"
  cloudinit_storage = "local-lvm"

  disks = [
    {
      size         = 32
      storage      = "local-lvm"
      storage_type = "lvm"
    },
    {
      size         = 128
      storage      = "local-lvm"
      storage_type = "lvm"
    },
  ]

  network_adapters = [
    {
      model    = "virtio"
      bridge   = "vmbr2"
      firewall = true
    },
    {
      model    = "virtio"
      bridge   = "k3s"
      firewall = true
    }
  ]
  boot_order = "order=virtio0;"
  ssh_keys   = var.ssh_public_key
  ipconfig = [
    "ip=dhcp",
    "ip=10.100.0.5/24"
  ]

}

