# variables
variable "install_istio" {
  description = "Install Istio"
  type        = bool
  default     = false
}

variable "istio" {
  description = "Map for overriding Istio Helm chart settings"
  type = object({
    name       = optional(string, "istio")
    repository = optional(string, "oci://cr.yandex/yc-marketplace/yandex-cloud/istio")
    chart      = optional(string, "istio")
    version    = optional(string, "1.21.2-1")
    namespace  = optional(string, "istio-system")

    addons_enabled = optional(bool, false)
  })
  default = {}
}

# helm
resource "helm_release" "istio" {
  count       = var.install_istio ? 1 : 0

  name        = var.istio.name
  repository  = var.istio.repository
  chart       = var.istio.chart
  version     = var.istio.version
  namespace   = var.istio.namespace

  create_namespace = true

  values = [
    yamlencode(
      {
        addons = {
          enabled = var.istio.addons_enabled
        }
      }
    )
  ]
}