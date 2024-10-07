# セットアップ用のSSH Key
variable "ssh_public_key" {
  type = string

}

variable "ssh_private_key" {
  type      = string
  sensitive = true

}

variable "pve_ssh_node" {
  type      = string
  sensitive = true
}
variable "pve_ssh_user" {
  type      = string
  sensitive = true

}
variable "pve_ssh_password" {
  type      = string
  sensitive = true

}

variable "snnipet_root" {
  type    = string
  default = "/mnt/pve/cephfs/snippets/"
}