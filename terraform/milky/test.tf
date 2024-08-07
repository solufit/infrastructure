resource "proxmox_lxc" "basic" {
  target_node = "milky-capella"
  hostname    = "lxc-clone"
  #id of lxc container to clone
  clone       = "10001"
}