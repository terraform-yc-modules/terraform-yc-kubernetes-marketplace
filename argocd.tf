# variables
variable "install_argocd" {
  description = "Install ArgoCD"
  type        = bool
  default     = false
}

variable "argocd" {
  description = "Map for overriding ArgoCD Helm chart settings"
  type = object({
    name       = optional(string)
    repository = optional(string)
    chart      = optional(string)
    version    = optional(string)
    namespace  = optional(string)
  })
  default = {}
}

# locals
locals {
  default_argocd = {
    name              = "argocd"
    repository        = "oci://cr.yandex/yc-marketplace/yandex-cloud/argo/chart"
    chart             = "argo-cd"
    version           = "7.3.11-2"
    namespace         = "argocd"
  }

  argocd = merge(
    local.default_argocd,
    { for k, v in var.argocd : k => v if v != null }
  )
}

# helm
resource "helm_release" "argocd" {
  count       = var.install_argocd ? 1 : 0

  name        = local.argocd.name
  repository  = local.argocd.repository
  chart       = local.argocd.chart
  version     = local.argocd.version
  namespace   = local.argocd.namespace

  create_namespace = true
}