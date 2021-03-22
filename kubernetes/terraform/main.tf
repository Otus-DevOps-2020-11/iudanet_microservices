provider "yandex" {
  zone                     = var.zone
  cloud_id                 = var.cloud_id
  folder_id                = var.folder_id
  service_account_key_file = var.service_account_key_file
}

resource "yandex_compute_instance" "k8s-master" {
  allow_stopping_for_update = true
  name                      = "k8s-master"
  platform_id               = "standard-v2"
  hostname                  = "k8s-master"
  resources {
    cores  = 4
    memory = 4
  }
  labels = {
    tags                       = "k8s"
    ansible_group              = "k8s_master"
    ansible_name               = "master"
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
      size     = 50
    }
  }

  network_interface {
    subnet_id = var.subnet_id
    nat       = true
  }
}


resource "yandex_compute_instance" "k8s-worker" {
  allow_stopping_for_update = true
  name                      = "k8s-worker"
  hostname                  = "k8s-worker"
  platform_id               = "standard-v2"
  resources {
    cores  = 4
    memory = 4
  }
  labels = {
    tags                       = "k8s"
    ansible_group              = "k8s_worker"
    ansible_name               = "worker"
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
      size     = 50
    }
  }

  network_interface {
    subnet_id = var.subnet_id
    nat       = true
  }
}
