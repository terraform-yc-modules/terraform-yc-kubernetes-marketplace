variable "cluster_id" {
  description = "The ID of the Kubernetes cluster where addons should be installed."
  type        = string
}

data "yandex_kubernetes_cluster" "target" {
  cluster_id = var.cluster_id
}

data "yandex_client_config" "client" {}