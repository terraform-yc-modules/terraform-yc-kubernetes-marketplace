# variables
variable "install_policy_reporter" {
  description = "Install Policy Reporter"
  type        = bool
  default     = false
}

variable "policy_reporter" {
  description = "Map for overriding Policy Reporter Helm chart settings"
  type = object({
    name       = optional(string, "policy-reporter")
    repository = optional(string, "oci://cr.yandex/yc-marketplace")
    chart      = optional(string, "policy-reporter")
    version    = optional(string, "2.13.11")
    namespace  = optional(string, "policy-reporter")

    cluster_id            = optional(string)
    custom_fields_enabled = optional(bool, false)
    ui_enabled            = optional(bool, false)
    s3_enabled            = optional(bool, false)
    s3_bucket             = optional(string)
    kinesis_enabled       = optional(bool, false)
    kinesis_endpoint      = optional(string)
    kinesis_stream        = optional(string)
    aws_key_value         = optional(string)
  })
  default = {}
}

# helm
resource "helm_release" "policy_reporter" {
  count = var.install_policy_reporter ? 1 : 0

  name       = var.policy_reporter.name
  repository = var.policy_reporter.repository
  chart      = var.policy_reporter.chart
  version    = var.policy_reporter.version
  namespace  = var.policy_reporter.namespace

  create_namespace = true

  values = [
    yamlencode(
      {
        clusterId = tostring(var.policy_reporter.cluster_id)
        clusterIdCustomField = {
          enabled = var.policy_reporter.custom_fields_enabled
        }
        ui = {
          enabled = var.policy_reporter.ui_enabled
        }
        target = {
          s3 = {
            enabled = var.policy_reporter.s3_enabled
            bucket  = tostring(var.policy_reporter.s3_bucket)
          }
          kinesis = {
            enabled    = var.policy_reporter.kinesis_enabled
            endpoint   = tostring(var.policy_reporter.kinesis_endpoint)
            streamName = tostring(var.policy_reporter.kinesis_stream)
          }
        }
        serviceaccountawskeyvalue = tostring(var.policy_reporter.aws_key_value)
      }
    )
  ]
}
