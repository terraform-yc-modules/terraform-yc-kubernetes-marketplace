# variables
variable "install_argocd" {
  description = "Install ArgoCD"
  type        = bool
  default     = false
}

variable "argocd" {
  description = "Map for overriding ArgoCD Helm chart settings"
  type = object({
    name       = optional(string, "argocd")
    repository = optional(string, "oci://cr.yandex/yc-marketplace/yandex-cloud/argo/chart")
    chart      = optional(string, "argo-cd")
    version    = optional(string, "7.3.11-2")
    namespace  = optional(string, "argocd")
  })
  default = {}
}

# helm
resource "helm_release" "argocd" {
  count       = var.install_argocd ? 1 : 0

  name        = var.argocd.name
  repository  = var.argocd.repository
  chart       = var.argocd.chart
  version     = var.argocd.version
  namespace   = var.argocd.namespace

  create_namespace = true
}