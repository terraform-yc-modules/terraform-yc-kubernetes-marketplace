# variables
variable "install_metrics_provider" {
  description = "Install Metrics Provider"
  type        = bool
  default     = false
}

variable "metrics_provider" {
  description = "Map for overriding Metrics Provider Helm chart settings"
  type = object({
    name       = optional(string)
    repository = optional(string)
    chart      = optional(string)
    version    = optional(string)
    namespace  = optional(string)

    metrics_folder_id               = optional(string)
    metrics_window                  = optional(string)
    downsampling_disabled           = optional(bool)
    downsampling_grid_aggregation   = optional(string)
    downsampling_gap_filling        = optional(string)
    downsampling_gap_max_points     = optional(number)
    downsampling_grid_interval      = optional(number)
    service_account_key             = optional(string)
  })
  default = {}
}

# locals
locals {
  default_metrics_provider = {
    name              = "metrics-provider"
    repository        = "oci://cr.yandex/yc-marketplace/yandex-cloud/metric-provider/chart"
    chart             = "metric-provider"
    version           = "0.1.12"
    namespace         = "metrics-provider"

    metrics_folder_id               = null
    metrics_window                  = "2m"
    downsampling_disabled           = true
    downsampling_grid_aggregation   = "AVG"
    downsampling_gap_filling        = "PREVIOUS"
    downsampling_gap_max_points     = 10
    downsampling_grid_interval      = 1
    service_account_key             = null
  }

  metrics_provider = merge(
    local.default_metrics_provider,
    { for k, v in var.metrics_provider : k => v if v != null }
  )
}

# helm
resource "helm_release" "metrics_provider" {
  count       = var.install_metrics_provider ? 1 : 0

  name        = local.metrics_provider.name
  repository  = local.metrics_provider.repository
  chart       = local.metrics_provider.chart
  version     = local.metrics_provider.version
  namespace   = local.metrics_provider.namespace

  create_namespace = true

  values = [ 
    yamlencode(
      {
        yandexMetrics = {
            folderId = tostring(local.metrics_provider.metrics_folder_id)
            window = tostring(local.metrics_provider.metrics_window)
            downsampling = {
                disabled = local.metrics_provider.downsampling_disabled
                gridAggregation = tostring(local.metrics_provider.downsampling_grid_aggregation)
                gapFilling = tostring(local.metrics_provider.downsampling_gap_filling)
                maxPoints = tonumber(local.metrics_provider.downsampling_gap_max_points)
                gridInterval = tonumber(local.metrics_provider.downsampling_grid_interval)
            }
            token = {
                serviceAccountJson = tostring(local.metrics_provider.service_account_key)
            }
        }
      }
    ) 
  ]
}