# variables
variable "install_vault" {
  description = "Install Vault"
  type        = bool
  default     = false
}

variable "vault" {
  description = "Map for overriding Vault Helm chart settings"
  type = object({
    name       = optional(string, "vault")
    repository = optional(string, "oci://cr.yandex/yc-marketplace/yandex-cloud/vault/chart")
    chart      = optional(string, "vault")
    version    = optional(string, "0.29.0_yckms")
    namespace  = optional(string, "vault")

    service_account_key = optional(string)
    kms_key_id          = optional(string)
  })
  default = {}
}

# helm
resource "helm_release" "vault" {
  count = var.install_vault ? 1 : 0

  name       = var.vault.name
  repository = var.vault.repository
  chart      = var.vault.chart
  version    = var.vault.version
  namespace  = var.vault.namespace

  create_namespace = true

  values = [
    yamlencode(
      {
        yandexKmsAuthJson = tostring(var.vault.service_account_key)
        yandexKmsKeyId    = tostring(var.vault.kms_key_id)
      }
    )
  ]
}
