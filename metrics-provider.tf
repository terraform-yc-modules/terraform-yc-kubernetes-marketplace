# variables
variable "install_metrics_provider" {
  description = "Install Metrics Provider"
  type        = bool
  default     = false
}

variable "metrics_provider" {
  description = "Map for overriding Metrics Provider Helm chart settings"
  type = object({
    name       = optional(string, "metrics-provider")
    repository = optional(string, "oci://cr.yandex/yc-marketplace/yandex-cloud/metric-provider/chart")
    chart      = optional(string, "metrics-provider")
    version    = optional(string, "0.1.12")
    namespace  = optional(string, "metrics-provider")

    metrics_folder_id             = optional(string)
    metrics_window                = optional(string, "2m")
    downsampling_disabled         = optional(bool, true)
    downsampling_grid_aggregation = optional(string, "AVG")
    downsampling_gap_filling      = optional(string, "PREVIOUS")
    downsampling_gap_max_points   = optional(number, 10)
    downsampling_grid_interval    = optional(number, 1)
    service_account_key           = optional(string)
  })
  default = {}
}

# helm
resource "helm_release" "metrics_provider" {
  count = var.install_metrics_provider ? 1 : 0

  name       = var.metrics_provider.name
  repository = var.metrics_provider.repository
  chart      = var.metrics_provider.chart
  version    = var.metrics_provider.version
  namespace  = var.metrics_provider.namespace

  create_namespace = true

  values = [
    yamlencode(
      {
        yandexMetrics = {
          folderId = tostring(var.metrics_provider.metrics_folder_id)
          window   = tostring(var.metrics_provider.metrics_window)
          downsampling = {
            disabled        = var.metrics_provider.downsampling_disabled
            gridAggregation = tostring(var.metrics_provider.downsampling_grid_aggregation)
            gapFilling      = tostring(var.metrics_provider.downsampling_gap_filling)
            maxPoints       = tonumber(var.metrics_provider.downsampling_gap_max_points)
            gridInterval    = tonumber(var.metrics_provider.downsampling_grid_interval)
          }
          token = {
            serviceAccountJson = tostring(var.metrics_provider.service_account_key)
          }
        }
      }
    )
  ]
}
