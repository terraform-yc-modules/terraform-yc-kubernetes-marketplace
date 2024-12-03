# variables
variable "install_cert_manager" {
  description = "Install cert-manager"
  type        = bool
  default     = false
}

variable "cert_manager" {
  description = "Map for overriding cert-manager Helm chart settings"
  type = object({
    name       = optional(string, "cert-manager")
    repository = optional(string, "oci://cr.yandex/yc-marketplace/yandex-cloud/cert-manager-webhook-yandex")
    chart      = optional(string, "cert-manager-webhook-yandex")
    version    = optional(string, "1.0.8-1")
    namespace  = optional(string, "cert-manager")

    service_account_key = optional(string)
    folder_id           = optional(string)
    email_address       = optional(string)
    letsencrypt_server  = optional(string, "https://acme-staging-v02.api.letsencrypt.org/directory")
  })
  default = {}
}

# helm
resource "helm_release" "cert_manager" {
  count = var.install_cert_manager ? 1 : 0

  name       = var.cert_manager.name
  repository = var.cert_manager.repository
  chart      = var.cert_manager.chart
  version    = var.cert_manager.version
  namespace  = var.cert_manager.namespace

  create_namespace = true

  values = [
    yamlencode(
      {
        config = {
          folder_id = tostring(var.cert_manager.folder_id)
          email     = tostring(var.cert_manager.email_address)
          auth = {
            json = tostring(var.cert_manager.service_account_key)
          }
        }
      }
    )
  ]
}
