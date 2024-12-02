# variables
variable "install_filebeat_oss" {
  description = "Install Filebeat OSS"
  type        = bool
  default     = false
}

variable "filebeat_oss" {
  description = "Map for overriding Filebeat OSS Helm chart settings"
  type = object({
    name       = optional(string, "filebeat")
    repository = optional(string, "oci://cr.yandex/yc-marketplace/yandex-cloud/filebeat-oss/chart")
    chart      = optional(string, "filebeat-oss")
    version    = optional(string, "7.12.1-1")
    namespace  = optional(string, "filebeat")

    opensearch_username   = optional(string, "admin")
    opensearch_password   = optional(string)
    opensearch_fqdn       = optional(string)
  })
  default = {}
}

# helm
resource "helm_release" "filebeat_oss" {
  count       = var.install_filebeat_oss ? 1 : 0

  name        = var.filebeat_oss.name
  repository  = var.filebeat_oss.repository
  chart       = var.filebeat_oss.chart
  version     = var.filebeat_oss.version
  namespace   = var.filebeat_oss.namespace

  create_namespace = true

  values = [ 
    yamlencode(
      {
        app = {
          username = tostring(var.filebeat_oss.opensearch_username)
          password = tostring(var.filebeat_oss.opensearch_password)
          url = tostring(var.filebeat_oss.opensearch_fqdn)
        }
      }
    ) 
  ]
}