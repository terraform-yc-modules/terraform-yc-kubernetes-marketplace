# variables
variable "install_nodelocal_dns" {
  description = "Install NodeLocal NS"
  type        = bool
  default     = false
}

variable "nodelocal_dns" {
  description = "Map for overriding NodeLocal DNS Helm chart settings"
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
  default_nodelocal_dns = {
    name       = "node-local-dns"
    repository = "oci://cr.yandex/yc-marketplace/yandex-cloud"
    chart      = "node-local-dns"
    version    = "1.5.1"
    namespace  = "node-local-dns"
  }

  nodelocal_dns = merge(
    local.default_nodelocal_dns,
    { for k, v in var.nodelocal_dns : k => v if v != null }
  )
}

# helm
resource "helm_release" "nodelocal_dns" {
  count       = var.install_nodelocal_dns ? 1 : 0

  name        = local.nodelocal_dns.name
  repository  = local.nodelocal_dns.repository
  chart       = local.nodelocal_dns.chart
  version     = local.nodelocal_dns.version
  namespace   = local.nodelocal_dns.namespace

  create_namespace = true
}