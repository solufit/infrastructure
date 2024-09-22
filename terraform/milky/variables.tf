# セットアップ用のSSH Key
variable "ssh_public_key" {
  type = string

}

variable "ssh_private_key" {
  type = string

}

variable "pve_ssh_node" {
  type = string
}
variable "pve_ssh_user" {
  type = string

}
variable "pve_ssh_password" {
  type = string

}

variable "snnipet_root" {
  type    = string
  default = "/mnt/pve/cephfs/snippets/"
}