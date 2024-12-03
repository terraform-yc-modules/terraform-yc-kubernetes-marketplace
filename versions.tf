terraform {
  required_version = ">= 1.0"

  required_providers {
    helm = {
      source  = "hashicorp/helm"
      version = ">= 2.9"
    }
    yandex = {
      source  = "yandex-cloud/yandex"
      version = ">= 0.108"
    }
  }
}

provider "helm" {
  kubernetes {
    cluster_ca_certificate = data.yandex_kubernetes_cluster.target.master[0].cluster_ca_certificate
    host                   = data.yandex_kubernetes_cluster.target.master[0].external_v4_endpoint
    token                  = data.yandex_client_config.client.iam_token
  }
}
