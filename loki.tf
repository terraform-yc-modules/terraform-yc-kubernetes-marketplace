# variables
variable "install_loki" {
  description = "Install Loki"
  type        = bool
  default     = false
}

variable "loki" {
  description = "Map for overriding Loki Helm chart settings"
  type = object({
    name       = optional(string)
    repository = optional(string)
    chart      = optional(string)
    version    = optional(string)
    namespace  = optional(string)

    object_storage_bucket   = optional(string)
    aws_key_value           = optional(string)
    promtail_enabled        = optional(bool)
  })
  default = {}
}

# locals
locals {
  default_loki = {
    name              = "loki"
    repository        = "oci://cr.yandex/yc-marketplace/yandex-cloud/grafana/loki/chart"
    chart             = "loki"
    version           = "1.2.0-7"
    namespace         = "loki"
    
    object_storage_bucket   = null
    aws_key_value           = null
    promtail_enabled        = true
  }

  loki = merge(
    local.default_loki,
    { for k, v in var.loki : k => v if v != null }
  )
}

# helm
resource "helm_release" "loki" {
  count       = var.install_loki ? 1 : 0

  name        = local.loki.name
  repository  = local.loki.repository
  chart       = local.loki.chart
  version     = local.loki.version
  namespace   = local.loki.namespace

  create_namespace = true

  values = [ 
    yamlencode(
      {
        global = {
            bucketname = tostring(local.loki.object_storage_bucket)
            serviceaccountawskeyvalue = tostring(local.loki.aws_key_value)
        }
        promtail = {
            enabled = local.loki.promtail_enabled
        }
      }
    ) 
  ]
}