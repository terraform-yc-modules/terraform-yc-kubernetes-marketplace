# variables
variable "install_vault" {
  description = "Install Vault"
  type        = bool
  default     = false
}

variable "vault" {
  description = "Map for overriding Vault Helm chart settings"
  type = object({
    name       = optional(string)
    repository = optional(string)
    chart      = optional(string)
    version    = optional(string)
    namespace  = optional(string)

    service_account_key     = optional(string)
    kms_key_id              = optional(string)
  })
  default = {}
}

# locals
locals {
  default_vault = {
    name              = "vault"
    repository        = "oci://cr.yandex/yc-marketplace/yandex-cloud/vault/chart"
    chart             = "vault"
    version           = "0.28.1+yckms"
    namespace         = "vault"
    
    service_account_key     = null
    kms_key_id              = null
  }

  vault = merge(
    local.default_vault,
    { for k, v in var.vault : k => v if v != null }
  )
}

# helm
resource "helm_release" "vault" {
  count       = var.install_vault ? 1 : 0

  name        = local.vault.name
  repository  = local.vault.repository
  chart       = local.vault.chart
  version     = local.vault.version
  namespace   = local.vault.namespace

  create_namespace = true

  values = [ 
    yamlencode(
      {
        yandexKmsAuthJson = tostring(local.vault.service_account_key)
        yandexKmsKeyId = tostring(local.vault.kms_key_id)
      }
    ) 
  ]
}