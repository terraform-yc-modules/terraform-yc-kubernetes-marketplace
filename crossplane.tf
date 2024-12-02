# variables
variable "install_crossplane" {
  description = "Install Crossplane"
  type        = bool
  default     = false
}

variable "crossplane" {
  description = "Map for overriding Crossplane Helm chart settings"
  type = object({
    name       = optional(string, "crossplane")
    repository = optional(string, "oci://cr.yandex/yc-marketplace/yandex-cloud/crossplane")
    chart      = optional(string, "crossplane")
    version    = optional(string, "1.15.0")
    namespace  = optional(string, "crossplane")

    service_account_key     = optional(string)
  })
  default = {}
}

# helm
resource "helm_release" "crossplane" {
  count       = var.install_crossplane ? 1 : 0

  name        = var.crossplane.name
  repository  = var.crossplane.repository
  chart       = var.crossplane.chart
  version     = var.crossplane.version
  namespace   = var.crossplane.namespace

  create_namespace = true

  values = [ 
    yamlencode(
      {
        providerJetYC = {
          creds = tostring(var.crossplane.service_account_key)
        }
      }
    ) 
  ]
}