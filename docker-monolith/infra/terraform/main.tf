provider "yandex" {
  zone                     = var.zone
  cloud_id                 = var.cloud_id
  folder_id                = var.folder_id
  service_account_key_file = var.service_account_key_file
}

resource "yandex_compute_instance" "docker" {
  allow_stopping_for_update = true
  name                      = "docker-${count.index}"
  platform_id               = "standard-v2"
  count                     = var.count_app
  resources {
    cores  = 2
    memory = 2
  }
  labels = {
    tags                       = "docker"
    ansible_group              = "docker"
    ansible_name               = "docker-${count.index}"
    ansible_host_var_test      = "test"
    ansible_group_var_username = "ubuntu"

  }
  zone = var.zone_app
  metadata = {
    ssh-keys = "${var.ssh_user}:${file(var.public_key_path)}"
  }
  boot_disk {
    initialize_params {
      # Указать id образа созданного в предыдущем домашем задании
      image_id = var.image_id
    }
  }

  network_interface {
    subnet_id = var.subnet_id
    nat       = true
  }
}
