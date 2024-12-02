# variables
variable "install_loki" {
  description = "Install Loki"
  type        = bool
  default     = false
}

variable "loki" {
  description = "Map for overriding Loki Helm chart settings"
  type = object({
    name       = optional(string, "loki")
    repository = optional(string, "oci://cr.yandex/yc-marketplace/yandex-cloud/grafana/loki/chart")
    chart      = optional(string, "loki")
    version    = optional(string, "1.2.0-7")
    namespace  = optional(string, "loki")

    object_storage_bucket   = optional(string)
    aws_key_value           = optional(string)
    promtail_enabled        = optional(bool, true)
  })
  default = {}
}

# helm
resource "helm_release" "loki" {
  count       = var.install_loki ? 1 : 0

  name        = var.loki.name
  repository  = var.loki.repository
  chart       = var.loki.chart
  version     = var.loki.version
  namespace   = var.loki.namespace

  create_namespace = true

  values = [ 
    yamlencode(
      {
        global = {
            bucketname = tostring(var.loki.object_storage_bucket)
            serviceaccountawskeyvalue = tostring(var.loki.aws_key_value)
        }
        promtail = {
            enabled = var.loki.promtail_enabled
        }
      }
    ) 
  ]
}