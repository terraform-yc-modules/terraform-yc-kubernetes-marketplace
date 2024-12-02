# variables
variable "install_falco" {
  description = "Install Falco"
  type        = bool
  default     = false
}

variable "falco" {
  description = "Map for overriding Falco Helm chart settings"
  type = object({
    name       = optional(string, "falco")
    repository = optional(string, "oci://cr.yandex/yc-marketplace")
    chart      = optional(string, "falco")
    version    = optional(string, "2.2.5")
    namespace  = optional(string, "falco")

    falco_sidekick_enabled      = optional(bool, false)
    falco_sidekick_replicacount = optional(number, 1)
  })
  default = {}
}

# helm
resource "helm_release" "falco" {
  count       = var.install_falco ? 1 : 0

  name        = var.falco.name
  repository  = var.falco.repository
  chart       = var.falco.chart
  version     = var.falco.version
  namespace   = var.falco.namespace

  create_namespace = true

  values = [ 
    yamlencode(
      {
        falcosidekick = {
            enabled = var.falco.falco_sidekick_enabled
            replicaCount = tonumber(var.falco.falco_sidekick_replicacount)
        }
      }
    ) 
  ]
}