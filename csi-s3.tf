# variables
variable "install_csi_s3" {
  description = "Install CSI S3"
  type        = bool
  default     = false
}

variable "csi_s3" {
  description = "Map for overriding CSI S3 Helm chart settings"
  type = object({
    name       = optional(string)
    repository = optional(string)
    chart      = optional(string)
    version    = optional(string)
    namespace  = optional(string)

    create_storage_class      = optional(bool)
    create_secret             = optional(bool)
    object_storage_key_id     = optional(string)
    object_storage_key_secret = optional(string)
    single_bucket             = optional(string)
    s3_endpoint               = optional(string)
    mount_options             = optional(string)
    reclaim_policy            = optional(string)
    storage_class_name        = optional(string)
    secret_name               = optional(string)
    tolerations_all           = optional(bool)
  })
  default = {}
}

# locals
locals {
  default_csi_s3 = {
    name              = "csi-s3"
    repository        = "oci://cr.yandex/yc-marketplace/yandex-cloud/csi-s3"
    chart             = "csi-s3"
    version           = "0.35.5"
    namespace         = "csi-s3"
    
    create_storage_class      = true
    create_secret             = true
    object_storage_key_id     = null
    object_storage_key_secret = null
    single_bucket             = null
    s3_endpoint               = "https://storage.yandexcloud.net"
    mount_options             = "--memory-limit 1000 --dir-mode 0777 --file-mode 0666"
    reclaim_policy            = "Delete"
    storage_class_name        = "csi-s3"
    secret_name               = "csi-s3-secret"
    tolerations_all           = false
  }

  csi_s3 = merge(
    local.default_csi_s3,
    { for k, v in var.csi_s3 : k => v if v != null }
  )
}

# helm
resource "helm_release" "csi_s3" {
  count       = var.install_csi_s3 ? 1 : 0

  name        = local.csi_s3.name
  repository  = local.csi_s3.repository
  chart       = local.csi_s3.chart
  version     = local.csi_s3.version
  namespace   = local.csi_s3.namespace

  create_namespace = true

  values = [ 
    yamlencode(
      {
        secret = {
          accessKey = tostring(local.csi_s3.object_storage_key_id)
          secretKey = tostring(local.csi_s3.object_storage_key_secret)
          create = local.csi_s3.create_secret
          endpoint = tostring(local.csi_s3.s3_endpoint)
          name = tostring(local.csi_s3.secret_name)
        }
        storageClass = {
          create = local.csi_s3.create_storage_class
          mountOptions = tostring(local.csi_s3.mount_options)
          name = tostring(local.csi_s3.storage_class_name)
          reclaimPolicy = tostring(local.csi_s3.reclaim_policy)
          singleBucket = tostring(local.csi_s3.single_bucket)
        }
        tolerations = {
          all = local.csi_s3.tolerations_all
        }
      }
    ) 
  ]
}