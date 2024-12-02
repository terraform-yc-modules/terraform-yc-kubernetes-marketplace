# variables
variable "install_chaos_mesh" {
  description = "Install Chaos Mesh"
  type        = bool
  default     = false
}

variable "chaos_mesh" {
  description = "Map for overriding Chaos Mesh Helm chart settings"
  type = object({
    name       = optional(string, "chaos-mesh")
    repository = optional(string, "oci://cr.yandex/yc-marketplace/yandex-cloud/chaos-mesh")
    chart      = optional(string, "chaos-mesh")
    version    = optional(string, "2.6.1-1b")
    namespace  = optional(string, "chaos-mesh")
  })
  default = {}
}

# helm
resource "helm_release" "chaos_mesh" {
  count       = var.install_chaos_mesh ? 1 : 0

  name        = var.chaos_mesh.name
  repository  = var.chaos_mesh.repository
  chart       = var.chaos_mesh.chart
  version     = var.chaos_mesh.version
  namespace   = var.chaos_mesh.namespace

  create_namespace = true
}