# variables
variable "install_kruise" {
  description = "Install Kruise"
  type        = bool
  default     = false
}

variable "kruise" {
  description = "Map for overriding Kruise Helm chart settings"
  type = object({
    name       = optional(string, "kruise")
    repository = optional(string, "oci://cr.yandex/yc-marketplace/yandex-cloud/kruise/chart")
    chart      = optional(string, "kruise")
    version    = optional(string, "1.5.0")
    namespace  = optional(string, "kruise")
  })
  default = {}
}

# helm
resource "helm_release" "kruise" {
  count = var.install_kruise ? 1 : 0

  name       = var.kruise.name
  repository = var.kruise.repository
  chart      = var.kruise.chart
  version    = var.kruise.version
  namespace  = var.kruise.namespace

  create_namespace = true
}
