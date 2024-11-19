# variables
variable "install_filebeat_oss" {
  description = "Install Filebeat OSS"
  type        = bool
  default     = false
}

variable "filebeat_oss" {
  description = "Map for overriding Filebeat OSS Helm chart settings"
  type = object({
    name       = optional(string)
    repository = optional(string)
    chart      = optional(string)
    version    = optional(string)
    namespace  = optional(string)

    opensearch_username   = optional(string)
    opensearch_password   = optional(string)
    opensearch_fqdn       = optional(string)
  })
  default = {}
}

# locals
locals {
  default_filebeat_oss = {
    name              = "filebeat"
    repository        = "oci://cr.yandex/yc-marketplace/yandex-cloud/filebeat-oss/chart"
    chart             = "filebeat-oss"
    version           = "7.12.1-1"
    namespace         = "filebeat"
    
    opensearch_username  = "admin"
    opensearch_password  = null
    opensearch_fqdn      = null
  }

  filebeat_oss = merge(
    local.default_filebeat_oss,
    { for k, v in var.filebeat_oss : k => v if v != null }
  )
}

# helm
resource "helm_release" "filebeat_oss" {
  count       = var.install_filebeat_oss ? 1 : 0

  name        = local.filebeat_oss.name
  repository  = local.filebeat_oss.repository
  chart       = local.filebeat_oss.chart
  version     = local.filebeat_oss.version
  namespace   = local.filebeat_oss.namespace

  create_namespace = true

  values = [ 
    yamlencode(
      {
        app = {
          username = tostring(local.filebeat_oss.opensearch_username)
          password = tostring(local.filebeat_oss.opensearch_password)
          url = tostring(local.filebeat_oss.opensearch_fqdn)
        }
      }
    ) 
  ]
}