# variables
variable "install_fluentbit" {
  description = "Install Fluentbit"
  type        = bool
  default     = false
}

variable "fluentbit" {
  description = "Map for overriding Fluentbit Helm chart settings"
  type = object({
    name       = optional(string)
    repository = optional(string)
    chart      = optional(string)
    version    = optional(string)
    namespace  = optional(string)

    log_group_id            = optional(string)
    service_account_key     = optional(string)
    export_to_s3_enabled    = optional(bool)
    object_storage_bucket   = optional(string)
    object_storage_key_id   = optional(string)
    object_storage_key_secret   = optional(string)
  })
  default = {}
}

# locals
locals {
  default_fluentbit = {
    name              = "fluent-bit"
    repository        = "oci://cr.yandex/yc-marketplace/yandex-cloud/fluent-bit"
    chart             = "fluent-bit"
    version           = "2.1.7-3"
    namespace         = "fluent-bit"
    
    log_group_id              = null
    service_account_key       = null
    export_to_s3_enabled      = false
    object_storage_bucket     = null
    object_storage_key_id     = null
    object_storage_key_secret = null
  }

  fluentbit = merge(
    local.default_fluentbit,
    { for k, v in var.fluentbit : k => v if v != null }
  )
}

# helm
resource "helm_release" "fluentbit" {
  count       = var.install_fluentbit ? 1 : 0

  name        = local.fluentbit.name
  repository  = local.fluentbit.repository
  chart       = local.fluentbit.chart
  version     = local.fluentbit.version
  namespace   = local.fluentbit.namespace

  create_namespace = true

  values = [ 
    yamlencode(
      {
        loggingGroupId = tostring(local.fluentbit.log_group_id)
        auth = {
          json = tostring(local.fluentbit.service_account_key)
        }
        objectStorageBucket = tostring(local.fluentbit.object_storage_bucket)
        serviceaccountawskeyvalue_generated = {
          accessKeyID = tostring(local.fluentbit.object_storage_key_id)
          secretAccessKey = tostring(local.fluentbit.object_storage_key_secret)
        }
        objectStorageExport = local.fluentbit.export_to_s3_enabled
      }
    ) 
  ]
}