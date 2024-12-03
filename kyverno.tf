# variables
variable "install_kyverno" {
  description = "Install Kyverno"
  type        = bool
  default     = false
}

variable "kyverno" {
  description = "Map for overriding Kyverno Helm chart settings"
  type = object({
    name       = optional(string, "kyverno")
    repository = optional(string, "oci://cr.yandex/yc-marketplace")
    chart      = optional(string, "multi-kyverno")
    version    = optional(string, "1.0.0")
    namespace  = optional(string, "kyverno")

    kyverno_policies_enabled = optional(bool, true)
    pod_security_profile     = optional(string, "baseline")
    failure_action           = optional(string, "audit") # audit, enforce
  })
  default = {}
}

# helm
resource "helm_release" "kyverno" {
  count = var.install_kyverno ? 1 : 0

  name       = var.kyverno.name
  repository = var.kyverno.repository
  chart      = var.kyverno.chart
  version    = var.kyverno.version
  namespace  = var.kyverno.namespace

  create_namespace = true

  values = [
    yamlencode(
      {
        enableKyvernoPolices    = var.kyverno.kyverno_policies_enabled
        podSecurityStandard     = tostring(var.kyverno.pod_security_profile)
        validationFailureAction = tostring(var.kyverno.failure_action)
      }
    )
  ]
}
