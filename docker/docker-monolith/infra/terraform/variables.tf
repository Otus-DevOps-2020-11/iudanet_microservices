variable cloud_id {
  description = "Cloud"
}
variable folder_id {
  description = "Folder"
}
variable zone {
  description = "Zone"
  # Значение по умолчанию
  default = "ru-central1-a"
}
variable "zone_app" {
  description = "Zone app"
}
variable public_key_path {
  # Описание переменной
  description = "Path to the public key used for ssh access"
}
variable private_key_path {
  description = "Path to the private key used for ssh access"
}
variable image_id {
  description = "Disk image"
}
variable subnet_id {
  description = "Subnet"
}
variable service_account_key_file {
  description = "key .json"
}

variable count_app {
  description = "count app"
  type        = number
  default     = 1
}

variable "ssh_user" {
  description = "ssh username"
  default     = "ubunt"
}

variable app_disk_image {
  description = "Disk image for reddit app"
  default     = "reddit-app-base"
}

variable db_disk_image {
  description = "Disk image for reddit db"
  default     = "reddit-db-base"
}

variable "static_access_key" {
  description = "access_key to s3"
}

variable "static_secret_key" {
  description = "secret_key to s3"
}

variable "run_provisioner" {
  description = "If true, run provisioner"
  type        = bool
}
