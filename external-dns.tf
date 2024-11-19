# variables
variable "install_external_dns" {
  description = "Install External DNS"
  type        = bool
  default     = false
}

variable "external_dns" {
  description = "Map for overriding External DNS Helm chart settings"
  type = object({
    name       = optional(string)
    repository = optional(string)
    chart      = optional(string)
    version    = optional(string)
    namespace  = optional(string)

    service_account_key     = optional(string)
    folder_id               = optional(string)
    txt_owner_id            = optional(string)
    txt_prefix              = optional(string)
  })
  default = {}
}

# locals
locals {
  default_external_dns = {
    name              = "external-dns"
    repository        = "oci://cr.yandex/yc-marketplace/yandex-cloud/externaldns/chart/"
    chart             = "externaldns"
    version           = "0.5.1-a"
    namespace         = "external-dns"

    service_account_key       = null
    folder_id                 = null
    txt_owner_id              = "external-dns"
    txt_prefix                = "external-dns-"
  }

  external_dns = merge(
    local.default_external_dns,
    { for k, v in var.external_dns : k => v if v != null }
  )
}

# helm
resource "helm_release" "external_dns" {
  count       = var.install_external_dns ? 1 : 0

  name        = local.external_dns.name
  repository  = local.external_dns.repository
  chart       = local.external_dns.chart
  version     = local.external_dns.version
  namespace   = local.external_dns.namespace

  create_namespace = true

  values = [ 
    yamlencode(
      {
        config = {
          auth = {
            json = tostring(local.external_dns.service_account_key)
          }
          folder_id = tostring(local.external_dns.folder_id)
          txt_owner_id = tostring(local.external_dns.txt_owner_id)
          txt_prefix = tostring(local.external_dns.txt_prefix)
        }
      }
    ) 
  ]
}