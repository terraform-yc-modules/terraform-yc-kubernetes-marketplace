# variables
variable "install_prometheus" {
  description = "Install Prometheus"
  type        = bool
  default     = false
}

variable "prometheus" {
  description = "Map for overriding Prometheus Helm chart settings"
  type = object({
    name       = optional(string)
    repository = optional(string)
    chart      = optional(string)
    version    = optional(string)
    namespace  = optional(string)

    prometheus_workspace_id = optional(string)
    api_key_value           = optional(string)
  })
  default = {}
}

# locals
locals {
  default_prometheus = {
    name              = "prometheus"
    repository        = "oci://cr.yandex/yc-marketplace/yandex-cloud/prometheus"
    chart             = "kube-prometheus-stack"
    version           = "57.2.0-1"
    namespace         = "prometheus"
    
    prometheus_workspace_id = null
    api_key_value           = null
  }

  prometheus = merge(
    local.default_prometheus,
    { for k, v in var.prometheus : k => v if v != null }
  )
}

# helm
resource "helm_release" "prometheus" {
  count       = var.install_prometheus ? 1 : 0

  name        = local.prometheus.name
  repository  = local.prometheus.repository
  chart       = local.prometheus.chart
  version     = local.prometheus.version
  namespace   = local.prometheus.namespace

  create_namespace = true

  values = [ 
    yamlencode(
      {
        prometheusWorkspaceId = tostring(local.prometheus.prometheus_workspace_id)
        iam_api_key_value = tostring(local.prometheus.api_key_value)
      }
    ) 
  ]
}