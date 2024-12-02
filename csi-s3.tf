# variables
variable "install_csi_s3" {
  description = "Install CSI S3"
  type        = bool
  default     = false
}

variable "csi_s3" {
  description = "Map for overriding CSI S3 Helm chart settings"
  type = object({
    name       = optional(string, "csi-s3")
    repository = optional(string, "oci://cr.yandex/yc-marketplace/yandex-cloud/csi-s3")
    chart      = optional(string, "csi-s3")
    version    = optional(string, "0.35.5")
    namespace  = optional(string, "csi-s3")

    create_storage_class      = optional(bool, true)
    create_secret             = optional(bool, true)
    object_storage_key_id     = optional(string)
    object_storage_key_secret = optional(string)
    single_bucket             = optional(string)
    s3_endpoint               = optional(string, "https://storage.yandexcloud.net")
    mount_options             = optional(string, "--memory-limit 1000 --dir-mode 0777 --file-mode 0666")
    reclaim_policy            = optional(string, "Delete")
    storage_class_name        = optional(string, "csi-s3")
    secret_name               = optional(string, "csi-s3-secret")
    tolerations_all           = optional(bool, false)
  })
  default = {}
}

# helm
resource "helm_release" "csi_s3" {
  count       = var.install_csi_s3 ? 1 : 0

  name        = var.csi_s3.name
  repository  = var.csi_s3.repository
  chart       = var.csi_s3.chart
  version     = var.csi_s3.version
  namespace   = var.csi_s3.namespace

  create_namespace = true

  values = [ 
    yamlencode(
      {
        secret = {
          accessKey = tostring(var.csi_s3.object_storage_key_id)
          secretKey = tostring(var.csi_s3.object_storage_key_secret)
          create = var.csi_s3.create_secret
          endpoint = tostring(var.csi_s3.s3_endpoint)
          name = tostring(var.csi_s3.secret_name)
        }
        storageClass = {
          create = var.csi_s3.create_storage_class
          mountOptions = tostring(var.csi_s3.mount_options)
          name = tostring(var.csi_s3.storage_class_name)
          reclaimPolicy = tostring(var.csi_s3.reclaim_policy)
          singleBucket = tostring(var.csi_s3.single_bucket)
        }
        tolerations = {
          all = var.csi_s3.tolerations_all
        }
      }
    ) 
  ]
}