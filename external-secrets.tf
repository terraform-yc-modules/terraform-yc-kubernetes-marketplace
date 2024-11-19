# variables
variable "install_external_secrets" {
  description = "Install External Secrets"
  type        = bool
  default     = false
}

variable "external_secrets" {
  description = "Map for overriding External Secrets Helm chart settings"
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
  default_external_secrets = {
    name              = "external-secrets"
    repository        = "oci://cr.yandex/yc-marketplace/yandex-cloud/external-secrets/chart"
    chart             = "external-secrets"
    version           = "0.9.20"
    namespace         = "external-secrets"

    service_account_key       = null
  }

  external_secrets = merge(
    local.default_external_secrets,
    { for k, v in var.external_secrets : k => v if v != null }
  )
}

# helm
resource "helm_release" "external_secrets" {
  count       = var.install_external_secrets ? 1 : 0

  name        = local.external_secrets.name
  repository  = local.external_secrets.repository
  chart       = local.external_secrets.chart
  version     = local.external_secrets.version
  namespace   = local.external_secrets.namespace

  create_namespace = true

  values = [ 
    yamlencode(
      {
        auth = {
          json = tostring(local.external_secrets.service_account_key)
        }
      }
    ) 
  ]
}