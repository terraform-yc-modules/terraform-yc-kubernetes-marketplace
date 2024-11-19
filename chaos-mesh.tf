# variables
variable "install_chaos_mesh" {
  description = "Install Chaos Mesh"
  type        = bool
  default     = false
}

variable "chaos_mesh" {
  description = "Map for overriding Chaos Mesh Helm chart settings"
  type = object({
    name       = optional(string)
    repository = optional(string)
    chart      = optional(string)
    version    = optional(string)
    namespace  = optional(string)
  })
  default = {}
}

# locals
locals {
  default_chaos_mesh = {
    name              = "chaos-mesh"
    repository        = "oci://cr.yandex/yc-marketplace/yandex-cloud/chaos-mesh"
    chart             = "chaos-mesh"
    version           = "2.6.1-1b"
    namespace         = "chaos-mesh"
  }

  chaos_mesh = merge(
    local.default_chaos_mesh,
    { for k, v in var.chaos_mesh : k => v if v != null }
  )
}

# helm
resource "helm_release" "chaos_mesh" {
  count       = var.install_chaos_mesh ? 1 : 0

  name        = local.chaos_mesh.name
  repository  = local.chaos_mesh.repository
  chart       = local.chaos_mesh.chart
  version     = local.chaos_mesh.version
  namespace   = local.chaos_mesh.namespace

  create_namespace = true
}