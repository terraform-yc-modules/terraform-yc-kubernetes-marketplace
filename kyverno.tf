# variables
variable "install_kyverno" {
  description = "Install Kyverno"
  type        = bool
  default     = false
}

variable "kyverno" {
  description = "Map for overriding Kyverno Helm chart settings"
  type = object({
    name       = optional(string)
    repository = optional(string)
    chart      = optional(string)
    version    = optional(string)
    namespace  = optional(string)

    kyverno_policies_enabled    = optional(bool)
    pod_security_profile        = optional(string)
    failure_action              = optional(string)
  })
  default = {}
}

# locals
locals {
  default_kyverno = {
    name              = "kyverno"
    repository        = "oci://cr.yandex/yc-marketplace"
    chart             = "multi-kyverno"
    version           = "1.0.0"
    namespace         = "kyverno"

    kyverno_policies_enabled    = true
    pod_security_profile        = "baseline"    # baseline, restricted, privileged
    failure_action              = "audit"       # audit, enforce
  }

  kyverno = merge(
    local.default_kyverno,
    { for k, v in var.kyverno : k => v if v != null }
  )
}

# helm
resource "helm_release" "kyverno" {
  count       = var.install_kyverno ? 1 : 0

  name        = local.kyverno.name
  repository  = local.kyverno.repository
  chart       = local.kyverno.chart
  version     = local.kyverno.version
  namespace   = local.kyverno.namespace

  create_namespace = true

  values = [ 
    yamlencode(
      {
        enableKyvernoPolices = local.kyverno.kyverno_policies_enabled
        podSecurityStandard = tostring(local.kyverno.pod_security_profile)
        validationFailureAction = tostring(local.kyverno.failure_action)
      }
    ) 
  ]
}