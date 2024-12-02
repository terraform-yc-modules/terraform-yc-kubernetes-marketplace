# variables
variable "install_external_secrets" {
  description = "Install External Secrets"
  type        = bool
  default     = false
}

variable "external_secrets" {
  description = "Map for overriding External Secrets Helm chart settings"
  type = object({
    name       = optional(string, "external-secrets")
    repository = optional(string, "oci://cr.yandex/yc-marketplace/yandex-cloud/external-secrets/chart")
    chart      = optional(string, "external-secrets")
    version    = optional(string, "0.9.20")
    namespace  = optional(string, "external-secrets")

    service_account_key     = optional(string)
  })
  default = {}
}

# helm
resource "helm_release" "external_secrets" {
  count       = var.install_external_secrets ? 1 : 0

  name        = var.external_secrets.name
  repository  = var.external_secrets.repository
  chart       = var.external_secrets.chart
  version     = var.external_secrets.version
  namespace   = var.external_secrets.namespace

  create_namespace = true

  values = [ 
    yamlencode(
      {
        auth = {
          json = tostring(var.external_secrets.service_account_key)
        }
      }
    ) 
  ]
}