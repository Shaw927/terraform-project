variable "yc_token" {
  description = "OAuth или IAM токен Yandex Cloud"
  type        = string
  sensitive   = true
}

variable "cloud_id" {
  description = "ID облака"
  type        = string
}

variable "folder_id" {
  description = "ID каталога"
  type        = string
}

variable "zone" {
  type    = string
  default = "ru-central1-a"
}

variable "subnet_cidr" {
  type    = string
  default = "10.10.10.0/24"
}

variable "vm_ssh_public_key" {
  description = "Публичный SSH ключ для доступа к VM"
  type        = string
}

variable "db_password" {
  type      = string
  sensitive = true
  default   = ""
}

variable "lockbox_secret_id" {
  type    = string
  default = ""
}

variable "vm_username" {
  type    = string
  default = "ubuntu"
}

variable "vm_cores" {
  type    = number
  default = 2
}

variable "vm_memory" {
  type    = number
  default = 2
}

variable "vm_disk_size" {
  type    = number
  default = 20
}

variable "image_tag" {
  type    = string
  default = "latest"
}

variable "db_name" {
  type    = string
  default = "webapp"
}

variable "db_user" {
  type    = string
  default = "webapp"
}

variable "vpc_name" {
  description = "VPC network name"
  type        = string
  default     = "final-project-vpc"
}
