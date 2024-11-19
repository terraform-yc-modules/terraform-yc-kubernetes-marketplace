# variables
variable "install_policy_reporter" {
  description = "Install Policy Reporter"
  type        = bool
  default     = false
}

variable "policy_reporter" {
  description = "Map for overriding Policy Reporter Helm chart settings"
  type = object({
    name       = optional(string)
    repository = optional(string)
    chart      = optional(string)
    version    = optional(string)
    namespace  = optional(string)

    cluster_id              = optional(string)
    custom_fields_enabled   = optional(bool)
    ui_enabled              = optional(bool)
    s3_enabled              = optional(bool)
    s3_bucket               = optional(string)
    kinesis_enabled         = optional(bool)
    kinesis_endpoint        = optional(string)
    kinesis_stream          = optional(string)
    aws_key_value           = optional(string)
  })
  default = {}
}

# locals
locals {
  default_policy_reporter = {
    name              = "policy-reporter"
    repository        = "oci://cr.yandex/yc-marketplace"
    chart             = "policy-reporter"
    version           = "2.13.11"
    namespace         = "policy-reporter"
    
    cluster_id              = null
    custom_fields_enabled   = false
    ui_enabled              = false
    s3_enabled              = false
    s3_bucket               = null
    kinesis_enabled         = false
    kinesis_endpoint        = null
    kinesis_stream          = null
    aws_key_value           = null
  }

  policy_reporter = merge(
    local.default_policy_reporter,
    { for k, v in var.policy_reporter : k => v if v != null }
  )
}

# helm
resource "helm_release" "policy_reporter" {
  count       = var.install_policy_reporter ? 1 : 0

  name        = local.policy_reporter.name
  repository  = local.policy_reporter.repository
  chart       = local.policy_reporter.chart
  version     = local.policy_reporter.version
  namespace   = local.policy_reporter.namespace

  create_namespace = true

  values = [ 
    yamlencode(
      {
        clusterId = tostring(local.policy_reporter.cluster_id)
        clusterIdCustomField = {
            enabled = local.policy_reporter.custom_fields_enabled
        }
        ui = {
            enabled = local.policy_reporter.ui_enabled
        }
        target = {
            s3 = {
                enabled = local.policy_reporter.s3_enabled
                bucket = tostring(local.policy_reporter.s3_bucket)
            }
            kinesis = {
                enabled = local.policy_reporter.kinesis_enabled
                endpoint = tostring(local.policy_reporter.kinesis_endpoint)
                streamName = tostring(local.policy_reporter.kinesis_stream)
            }
        }
        serviceaccountawskeyvalue = tostring(local.policy_reporter.aws_key_value)
      }
    ) 
  ]
}