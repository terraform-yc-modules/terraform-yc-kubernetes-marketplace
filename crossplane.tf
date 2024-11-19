# variables
variable "install_crossplane" {
  description = "Install Crossplane"
  type        = bool
  default     = false
}

variable "crossplane" {
  description = "Map for overriding Crossplane Helm chart settings"
  type = object({
    name       = optional(string)
    repository = optional(string)
    chart      = optional(string)
    version    = optional(string)
    namespace  = optional(string)

    service_account_key     = optional(string)
  })
  default = {}
}

# locals
locals {
  default_crossplane = {
    name              = "crossplane"
    repository        = "oci://cr.yandex/yc-marketplace/yandex-cloud/crossplane"
    chart             = "crossplane"
    version           = "1.15.0"
    namespace         = "crossplane"

    service_account_key       = null
  }

  crossplane = merge(
    local.default_crossplane,
    { for k, v in var.crossplane : k => v if v != null }
  )
}

# helm
resource "helm_release" "crossplane" {
  count       = var.install_crossplane ? 1 : 0

  name        = local.crossplane.name
  repository  = local.crossplane.repository
  chart       = local.crossplane.chart
  version     = local.crossplane.version
  namespace   = local.crossplane.namespace

  create_namespace = true

  values = [ 
    yamlencode(
      {
        providerJetYC = {
          creds = tostring(local.crossplane.service_account_key)
        }
      }
    ) 
  ]
}