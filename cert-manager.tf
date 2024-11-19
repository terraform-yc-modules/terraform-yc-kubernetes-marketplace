# variables
variable "install_cert_manager" {
  description = "Install cert-manager"
  type        = bool
  default     = false
}

variable "cert_manager" {
  description = "Map for overriding cert-manager Helm chart settings"
  type = object({
    name       = optional(string)
    repository = optional(string)
    chart      = optional(string)
    version    = optional(string)
    namespace  = optional(string)

    service_account_key     = optional(string)
    folder_id               = optional(string)
    email_address           = optional(string)
    letsencrypt_server      = optional(string)
  })
  default = {}
}

# locals
locals {
  default_cert_manager = {
    name              = "cert-manager"
    repository        = "oci://cr.yandex/yc-marketplace/yandex-cloud/cert-manager-webhook-yandex"
    chart             = "cert-manager-webhook-yandex"
    version           = "1.0.8-1"
    namespace         = "cert-manager"
    
    service_account_key     = null
    folder_id               = null
    email_address           = null
    letsencrypt_server      = "https://acme-staging-v02.api.letsencrypt.org/directory"
  }

  cert_manager = merge(
    local.default_cert_manager,
    { for k, v in var.cert_manager : k => v if v != null }
  )
}

# helm
resource "helm_release" "cert_manager" {
  count       = var.install_cert_manager ? 1 : 0

  name        = local.cert_manager.name
  repository  = local.cert_manager.repository
  chart       = local.cert_manager.chart
  version     = local.cert_manager.version
  namespace   = local.cert_manager.namespace

  create_namespace = true

  values = [ 
    yamlencode(
      {
        config = {
          folder_id = tostring(local.cert_manager.folder_id)
          email = tostring(local.cert_manager.email_address)
          auth = {
            json = tostring(local.cert_manager.service_account_key)
          }
        }
      }
    ) 
  ]
}