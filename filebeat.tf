# variables
variable "install_filebeat" {
  description = "Install Filebeat"
  type        = bool
  default     = false
}

variable "filebeat" {
  description = "Map for overriding Filebeat Helm chart settings"
  type = object({
    name       = optional(string, "filebeat")
    repository = optional(string, "oci://cr.yandex/yc-marketplace/yandex-cloud/filebeat/chart")
    chart      = optional(string, "filebeat")
    version    = optional(string, "7.16.3-5")
    namespace  = optional(string, "filebeat")

    elasticsearch_username = optional(string, "admin")
    elasticsearch_password = optional(string)
    elasticsearch_fqdn     = optional(string)
  })
  default = {}
}

# helm
resource "helm_release" "filebeat" {
  count = var.install_filebeat ? 1 : 0

  name       = var.filebeat.name
  repository = var.filebeat.repository
  chart      = var.filebeat.chart
  version    = var.filebeat.version
  namespace  = var.filebeat.namespace

  create_namespace = true

  values = [
    yamlencode(
      {
        app = {
          username = tostring(var.filebeat.elasticsearch_username)
          password = tostring(var.filebeat.elasticsearch_password)
          url      = tostring(var.filebeat.elasticsearch_fqdn)
        }
      }
    )
  ]
}
