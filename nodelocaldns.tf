# variables
variable "install_nodelocal_dns" {
  description = "Install NodeLocal NS"
  type        = bool
  default     = false
}

variable "nodelocal_dns" {
  description = "Map for overriding NodeLocal DNS Helm chart settings"
  type = object({
    name       = optional(string, "node-local-dns")
    repository = optional(string, "oci://cr.yandex/yc-marketplace/yandex-cloud")
    chart      = optional(string, "node-local-dns")
    version    = optional(string, "1.5.1")
    namespace  = optional(string, "node-local-dns")
  })
  default = {}
}

# helm
resource "helm_release" "nodelocal_dns" {
  count       = var.install_nodelocal_dns ? 1 : 0

  name        = var.nodelocal_dns.name
  repository  = var.nodelocal_dns.repository
  chart       = var.nodelocal_dns.chart
  version     = var.nodelocal_dns.version
  namespace   = var.nodelocal_dns.namespace

  create_namespace = true
}