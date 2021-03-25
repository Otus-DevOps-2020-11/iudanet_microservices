resource "yandex_iam_service_account" "iam_k8s_service" {
  name        = "k8ssvcmanager"
  description = "k8s service manager"

}
resource "yandex_iam_service_account" "iam_k8s_node" {
  name        = "k8snodemanager"
  description = "k8s node manager"
}

resource "yandex_resourcemanager_folder_iam_binding" "iam_k8s_node_vpc_admin" {
  role      = "vpc.publicAdmin"
  folder_id = var.folder_id
  members = [
    "serviceAccount:${yandex_iam_service_account.iam_k8s_node.id}",
    "serviceAccount:${yandex_iam_service_account.iam_k8s_service.id}"
  ]
}

resource "yandex_resourcemanager_folder_iam_binding" "iam_k8s_node_k8s_editor" {
  role      = "k8s.clusters.agent"
  folder_id = var.folder_id
  members = [
    "serviceAccount:${yandex_iam_service_account.iam_k8s_node.id}",
    "serviceAccount:${yandex_iam_service_account.iam_k8s_service.id}"
  ]
}
