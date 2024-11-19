# variables
variable "install_filebeat" {
  description = "Install Filebeat"
  type        = bool
  default     = false
}

variable "filebeat" {
  description = "Map for overriding Filebeat Helm chart settings"
  type = object({
    name       = optional(string)
    repository = optional(string)
    chart      = optional(string)
    version    = optional(string)
    namespace  = optional(string)

    elasticsearch_username   = optional(string)
    elasticsearch_password   = optional(string)
    elasticsearch_fqdn       = optional(string)
  })
  default = {}
}

# locals
locals {
  default_filebeat = {
    name              = "filebeat"
    repository        = "oci://cr.yandex/yc-marketplace/yandex-cloud/filebeat/chart"
    chart             = "filebeat"
    version           = "7.16.3-5"
    namespace         = "filebeat"
    
    elasticsearch_username  = "admin"
    elasticsearch_password  = null
    elasticsearch_fqdn      = null
  }

  filebeat = merge(
    local.default_filebeat,
    { for k, v in var.filebeat : k => v if v != null }
  )
}

# helm
resource "helm_release" "filebeat" {
  count       = var.install_filebeat ? 1 : 0

  name        = local.filebeat.name
  repository  = local.filebeat.repository
  chart       = local.filebeat.chart
  version     = local.filebeat.version
  namespace   = local.filebeat.namespace

  create_namespace = true

  values = [ 
    yamlencode(
      {
        app = {
          username = tostring(local.filebeat.elasticsearch_username)
          password = tostring(local.filebeat.elasticsearch_password)
          url = tostring(local.filebeat.elasticsearch_fqdn)
        }
      }
    ) 
  ]
}