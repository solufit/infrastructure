```md
module "proxmox_vm" {
  source = "./modules/proxmox-vm"

  vm_name        = "multi-disk-vm"
  vm_description = "VM with multiple disks and network adapters"
  target_node    = "proxmox-node1"
  resource_pool  = "pool0"
  template_name  = "ubuntu-cloud-template"
  
  cpu_cores      = 2
  cpu_sockets    = 1
  memory         = 4096
  
  cloudinit_storage = "local-lvm"
  
  disks = [
    {
      size         = 32
      storage      = "local-lvm"
      storage_type = "lvm"
    },
    {
      size         = 64
      storage      = "ceph-pool"
      storage_type = "rbd"
      iothread     = true
      discard      = true
    }
  ]
  
  network_adapters = [
    {
      model    = "virtio"
      bridge   = "vmbr0"
      vlan_tag = 100
    },
    {
      model    = "virtio"
      bridge   = "vmbr1"
      vlan_tag = 200
    }
  ]
  
  boot_order    = "order=virtio0;virtio1"
  ipconfig      = "ip=192.168.1.100/24,gw=192.168.1.1"
  ssh_keys      = file("~/.ssh/id_rsa.pub")
}
```