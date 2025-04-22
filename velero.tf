# variables
variable "install_velero" {
  description = "Install Velero"
  type        = bool
  default     = false
}

variable "velero" {
  description = "Map for overriding Velero Helm chart settings"
  type = object({
    name       = optional(string, "velero")
    repository = optional(string, "oci://cr.yandex/yc-marketplace/yandex-cloud/velero")
    chart      = optional(string, "velero")
    version    = optional(string, "8.5.0-4")
    namespace  = optional(string, "velero")

    object_storage_bucket = optional(string)
    aws_key_value         = optional(string)
  })
  default = {}
}

# helm
resource "helm_release" "velero" {
  count = var.install_velero ? 1 : 0

  name       = var.velero.name
  repository = var.velero.repository
  chart      = var.velero.chart
  version    = var.velero.version
  namespace  = var.velero.namespace

  create_namespace = true

  values = [
    yamlencode(
      {
        serviceaccountawskeyvalue = tostring(var.velero.aws_key_value)
        configuration = {
          backupStorageLocation = {
            bucket = tostring(var.velero.object_storage_bucket)
          }
        }
      }
    )
  ]
}
