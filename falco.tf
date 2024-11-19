# variables
variable "install_falco" {
  description = "Install Falco"
  type        = bool
  default     = false
}

variable "falco" {
  description = "Map for overriding Falco Helm chart settings"
  type = object({
    name       = optional(string)
    repository = optional(string)
    chart      = optional(string)
    version    = optional(string)
    namespace  = optional(string)

    falco_sidekick_enabled      = optional(bool)
    falco_sidekick_replicacount = optional(number)
  })
  default = {}
}

# locals
locals {
  default_falco = {
    name              = "falco"
    repository        = "oci://cr.yandex/yc-marketplace"
    chart             = "falco"
    version           = "2.2.5"
    namespace         = "falco"
    
    falco_sidekick_enabled      = false
    falco_sidekick_replicacount = 1
  }

  falco = merge(
    local.default_falco,
    { for k, v in var.falco : k => v if v != null }
  )
}

# helm
resource "helm_release" "falco" {
  count       = var.install_falco ? 1 : 0

  name        = local.falco.name
  repository  = local.falco.repository
  chart       = local.falco.chart
  version     = local.falco.version
  namespace   = local.falco.namespace

  create_namespace = true

  values = [ 
    yamlencode(
      {
        falcosidekick = {
            enabled = local.falco.falco_sidekick_enabled
            replicaCount = tonumber(local.falco.falco_sidekick_replicacount)
        }
      }
    ) 
  ]
}