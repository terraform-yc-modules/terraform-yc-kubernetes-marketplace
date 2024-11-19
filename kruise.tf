# variables
variable "install_kruise" {
  description = "Install Kruise"
  type        = bool
  default     = false
}

variable "kruise" {
  description = "Map for overriding Kruise Helm chart settings"
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
  default_kruise = {
    name              = "kruise"
    repository        = "oci://cr.yandex/yc-marketplace/yandex-cloud/kruise/chart"
    chart             = "kruise"
    version           = "1.5.0"
    namespace         = "kruise"
  }

  kruise = merge(
    local.default_kruise,
    { for k, v in var.kruise : k => v if v != null }
  )
}

# helm
resource "helm_release" "kruise" {
  count       = var.install_kruise ? 1 : 0

  name        = local.kruise.name
  repository  = local.kruise.repository
  chart       = local.kruise.chart
  version     = local.kruise.version
  namespace   = local.kruise.namespace

  create_namespace = true
}