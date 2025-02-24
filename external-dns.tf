# variables
variable "install_external_dns" {
  description = "Install External DNS"
  type        = bool
  default     = false
}

variable "external_dns" {
  description = "Map for overriding External DNS Helm chart settings"
  type = object({
    name       = optional(string, "external-dns")
    repository = optional(string, "oci://cr.yandex/yc-marketplace/yandex-cloud/externaldns/chart/")
    chart      = optional(string, "externaldns")
    version    = optional(string, "0.5.1-b")
    namespace  = optional(string, "external-dns")

    service_account_key = optional(string)
    folder_id           = optional(string)
  })
  default = {}
}

# helm
resource "helm_release" "external_dns" {
  count = var.install_external_dns ? 1 : 0

  name       = var.external_dns.name
  repository = var.external_dns.repository
  chart      = var.external_dns.chart
  version    = var.external_dns.version
  namespace  = var.external_dns.namespace

  create_namespace = true

  values = [
    yamlencode(
      {
        config = {
          auth = {
            json = tostring(var.external_dns.service_account_key)
          }
          folder_id    = tostring(var.external_dns.folder_id)
        }
      }
    )
  ]
}
