# variables
variable "install_prometheus" {
  description = "Install Prometheus"
  type        = bool
  default     = false
}

variable "prometheus" {
  description = "Map for overriding Prometheus Helm chart settings"
  type = object({
    name       = optional(string, "prometheus")
    repository = optional(string, "oci://cr.yandex/yc-marketplace/yandex-cloud/prometheus")
    chart      = optional(string, "kube-prometheus-stack")
    version    = optional(string, "57.2.0-1")
    namespace  = optional(string, "prometheus")

    prometheus_workspace_id = optional(string)
    api_key_value           = optional(string)
  })
  default = {}
}

# helm
resource "helm_release" "prometheus" {
  count = var.install_prometheus ? 1 : 0

  name       = var.prometheus.name
  repository = var.prometheus.repository
  chart      = var.prometheus.chart
  version    = var.prometheus.version
  namespace  = var.prometheus.namespace

  create_namespace = true

  values = [
    yamlencode(
      {
        prometheusWorkspaceId = tostring(var.prometheus.prometheus_workspace_id)
        iam_api_key_value     = tostring(var.prometheus.api_key_value)
      }
    )
  ]
}
