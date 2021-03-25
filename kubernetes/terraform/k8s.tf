resource "yandex_vpc_subnet" "subnet_resource_name" {
  v4_cidr_blocks = ["10.0.0.0/16"]
  zone           = "ru-central1-a"
  network_id     = yandex_vpc_network.network_resource_name.id
}
resource "yandex_vpc_network" "network_resource_name" {
  name = "k8s-network"
}

resource "yandex_kms_symmetric_key" "kms_key_resource_name" {

}
resource "yandex_kubernetes_cluster" "zonal_cluster_resource_name" {
  name        = "name"
  description = "description"

  network_id = yandex_vpc_network.network_resource_name.id

  master {
    version = "1.19"
    zonal {
      zone      = yandex_vpc_subnet.subnet_resource_name.zone
      subnet_id = yandex_vpc_subnet.subnet_resource_name.id
    }

    public_ip = true

    # security_group_ids = [yandex_vpc_security_group.security_group_name.id]

    maintenance_policy {
      auto_upgrade = true

      maintenance_window {
        start_time = "15:00"
        duration   = "3h"
      }
    }
  }

  service_account_id      = yandex_iam_service_account.iam_k8s_service.id
  node_service_account_id = yandex_iam_service_account.iam_k8s_node.id


  release_channel         = "RAPID"
  network_policy_provider = "CALICO"

  kms_provider {
    key_id = yandex_kms_symmetric_key.kms_key_resource_name.id
  }

}


resource "yandex_kubernetes_node_group" "k8s-workers" {
  cluster_id  = yandex_kubernetes_cluster.zonal_cluster_resource_name.id
  name        = "k8s-workers"
  description = "worker node"
  version     = "1.19"

  instance_template {
    platform_id = "standard-v2"

    network_interface {
      nat        = true
      subnet_ids = [yandex_vpc_subnet.subnet_resource_name.id]
    }

    resources {
      memory = 8
      cores  = 4
    }

    boot_disk {
      type = "network-hdd"
      size = 64
    }
    metadata = {
      ssh-keys = format("%s:%s", var.ssh_user, file(var.public_key_path))
    }
    scheduling_policy {
      preemptible = false
    }
  }

  scale_policy {
    fixed_scale {
      size = 2
    }
  }

  allocation_policy {
    location {
      zone = var.zone
    }
  }
}
