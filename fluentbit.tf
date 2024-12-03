# variables
variable "install_fluentbit" {
  description = "Install Fluentbit"
  type        = bool
  default     = false
}

variable "fluentbit" {
  description = "Map for overriding Fluentbit Helm chart settings"
  type = object({
    name       = optional(string, "fluent-bit")
    repository = optional(string, "oci://cr.yandex/yc-marketplace/yandex-cloud/fluent-bit")
    chart      = optional(string, "fluent-bit")
    version    = optional(string, "2.1.7-3")
    namespace  = optional(string, "fluent-bit")

    log_group_id              = optional(string)
    service_account_key       = optional(string)
    export_to_s3_enabled      = optional(bool, false)
    object_storage_bucket     = optional(string)
    object_storage_key_id     = optional(string)
    object_storage_key_secret = optional(string)
  })
  default = {}
}

# helm
resource "helm_release" "fluentbit" {
  count = var.install_fluentbit ? 1 : 0

  name       = var.fluentbit.name
  repository = var.fluentbit.repository
  chart      = var.fluentbit.chart
  version    = var.fluentbit.version
  namespace  = var.fluentbit.namespace

  create_namespace = true

  values = [
    yamlencode(
      {
        loggingGroupId = tostring(var.fluentbit.log_group_id)
        auth = {
          json = tostring(var.fluentbit.service_account_key)
        }
        objectStorageBucket = tostring(var.fluentbit.object_storage_bucket)
        serviceaccountawskeyvalue_generated = {
          accessKeyID     = tostring(var.fluentbit.object_storage_key_id)
          secretAccessKey = tostring(var.fluentbit.object_storage_key_secret)
        }
        objectStorageExport = var.fluentbit.export_to_s3_enabled
      }
    )
  ]
}
