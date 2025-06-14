variable "client_id" {}
variable "client_secret" {}
variable "tenant_id" {}
variable "subscription_id" {}

variable "resource_group_name" {
  default = "ansible-devops-rg"
}

variable "location" {
  default = "eastus"
}

variable "vm_name" {
  default = "ansible-vm"
}

variable "vm_size" {
  default = "Standard_B1s"
}

variable "admin_username" {
  default = "sathish"
}

variable "ssh_public_key_path" {
  default = "~/.ssh/auction-vm-key.pub"
}
