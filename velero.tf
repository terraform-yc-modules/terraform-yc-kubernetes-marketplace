# variables
variable "install_velero" {
  description = "Install Velero"
  type        = bool
  default     = false
}

variable "velero" {
  description = "Map for overriding Velero Helm chart settings"
  type = object({
    name       = optional(string)
    repository = optional(string)
    chart      = optional(string)
    version    = optional(string)
    namespace  = optional(string)

    object_storage_bucket   = optional(string)
    aws_key_value           = optional(string)
  })
  default = {}
}

# locals
locals {
  devault_velero = {
    name              = "velero"
    repository        = "oci://cr.yandex/yc-marketplace/yandex-cloud/velero"
    chart             = "velero"
    version           = "2.30.4-1"
    namespace         = "velero"
    
    object_storage_bucket   = null
    aws_key_value           = null
  }

  velero = merge(
    local.devault_velero,
    { for k, v in var.velero : k => v if v != null }
  )
}

# helm
resource "helm_release" "velero" {
  count       = var.install_velero ? 1 : 0

  name        = local.velero.name
  repository  = local.velero.repository
  chart       = local.velero.chart
  version     = local.velero.version
  namespace   = local.velero.namespace

  create_namespace = true

  values = [ 
    yamlencode(
      {
        serviceaccountawskeyvalue = tostring(local.velero.aws_key_value)
        configuration = {
            backupStorageLocation = {
                bucket = tostring(local.velero.object_storage_bucket)
            }
        }
      }
    ) 
  ]
}