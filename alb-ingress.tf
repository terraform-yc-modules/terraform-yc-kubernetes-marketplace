# variables
variable "install_alb_ingress" {
  description = "Install ALB Ingress Controller"
  type        = bool
  default     = false
}

variable "alb_ingress" {
  description = "Map for overriding ALB Ingress Controller Helm chart settings"
  type = object({
    name       = optional(string)
    repository = optional(string)
    chart      = optional(string)
    version    = optional(string)
    namespace  = optional(string)

    folder_id               = optional(string)
    cluster_id              = optional(string)
    service_account_key     = optional(string)
    healthchecks_enabled    = optional(bool)
  })
  default = {}
}

# locals
locals {
  default_alb_ingress = {
    name              = "alb-ingress"
    repository        = "oci://cr.yandex/yc-marketplace/yandex-cloud/yc-alb-ingress"
    chart             = "yc-alb-ingress-controller-chart"
    version           = "v0.2.11"
    namespace         = "alb-ingress"
    
    folder_id               = null
    cluster_id              = null
    service_account_key     = null
    healthchecks_enabled    = false
  }

  alb_ingress = merge(
    local.default_alb_ingress,
    { for k, v in var.alb_ingress : k => v if v != null }
  )
}

# helm
resource "helm_release" "alb_ingress" {
  count       = var.install_alb_ingress ? 1 : 0

  name        = local.alb_ingress.name
  repository  = local.alb_ingress.repository
  chart       = local.alb_ingress.chart
  version     = local.alb_ingress.version
  namespace   = local.alb_ingress.namespace

  create_namespace = true

  values = [ 
    yamlencode(
      {
        folderId = tostring(local.alb_ingress.folder_id)
        clusterId = tostring(local.alb_ingress.cluster_id)
        saKeySecretKey = tostring(local.alb_ingress.service_account_key)
        enableDefaultHealthChecks = local.alb_ingress.healthchecks_enabled
      }
    ) 
  ]
}