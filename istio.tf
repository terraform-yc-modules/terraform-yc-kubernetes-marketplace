# variables
variable "install_istio" {
  description = "Install Istio"
  type        = bool
  default     = false
}

variable "istio" {
  description = "Map for overriding Istio Helm chart settings"
  type = object({
    name       = optional(string)
    repository = optional(string)
    chart      = optional(string)
    version    = optional(string)
    namespace  = optional(string)

    addons_enabled = optional(bool)
  })
  default = {}
}

# locals
locals {
  default_istio = {
    name              = "istio"
    repository        = "oci://cr.yandex/yc-marketplace/yandex-cloud/istio"
    chart             = "istio"
    version           = "1.21.2-1"
    namespace         = "istio-system"

    addons_enabled    = false
  }

  istio = merge(
    local.default_istio,
    { for k, v in var.istio : k => v if v != null }
  )
}

# helm
resource "helm_release" "istio" {
  count       = var.install_istio ? 1 : 0

  name        = local.istio.name
  repository  = local.istio.repository
  chart       = local.istio.chart
  version     = local.istio.version
  namespace   = local.istio.namespace

  create_namespace = true

  values = [
    yamlencode(
      {
        addons = {
          enabled = local.istio.addons_enabled
        }
      }
    )
  ]
}