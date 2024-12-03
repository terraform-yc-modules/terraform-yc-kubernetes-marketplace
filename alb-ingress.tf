# variables
variable "install_alb_ingress" {
  description = "Install ALB Ingress Controller"
  type        = bool
  default     = false
}

variable "alb_ingress" {
  description = "Map for overriding ALB Ingress Controller Helm chart settings"
  type = object({
    name       = optional(string, "alb-ingress")
    repository = optional(string, "oci://cr.yandex/yc-marketplace/yandex-cloud/yc-alb-ingress")
    chart      = optional(string, "yc-alb-ingress-controller-chart")
    version    = optional(string, "v0.2.11")
    namespace  = optional(string, "alb-ingress")

    folder_id            = optional(string, null)
    cluster_id           = optional(string, null)
    service_account_key  = optional(string, null)
    healthchecks_enabled = optional(bool, false)
  })
  default = {}
}

# helm
resource "helm_release" "alb_ingress" {
  count = var.install_alb_ingress ? 1 : 0

  name       = var.alb_ingress.name
  repository = var.alb_ingress.repository
  chart      = var.alb_ingress.chart
  version    = var.alb_ingress.version
  namespace  = var.alb_ingress.namespace

  create_namespace = true

  values = [
    yamlencode(
      {
        folderId                  = tostring(var.alb_ingress.folder_id)
        clusterId                 = tostring(var.alb_ingress.cluster_id)
        saKeySecretKey            = tostring(var.alb_ingress.service_account_key)
        enableDefaultHealthChecks = var.alb_ingress.healthchecks_enabled
      }
    )
  ]
}
