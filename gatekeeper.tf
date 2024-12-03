# variables
variable "install_gatekeeper" {
  description = "Install Gatekeeper"
  type        = bool
  default     = false
}

variable "gatekeeper" {
  description = "Map for overriding Gatekeeper Helm chart settings"
  type = object({
    name       = optional(string, "gatekeeper")
    repository = optional(string, "oci://cr.yandex/yc-marketplace")
    chart      = optional(string, "gatekeeper")
    version    = optional(string, "3.12.0")
    namespace  = optional(string, "gatekeeper")

    audit_interval           = optional(number, 60)
    violation_limit          = optional(number, 20)
    match_kind_enabled       = optional(bool, false)
    emit_events_enabled      = optional(bool, false)
    namespace_events_enabled = optional(bool, false)
    external_data_enabled    = optional(bool, false)
  })
  default = {}
}

# helm
resource "helm_release" "gatekeeper" {
  count = var.install_gatekeeper ? 1 : 0

  name       = var.gatekeeper.name
  repository = var.gatekeeper.repository
  chart      = var.gatekeeper.chart
  version    = var.gatekeeper.version
  namespace  = var.gatekeeper.namespace

  create_namespace = true

  values = [
    yamlencode(
      {
        auditInterval                = tonumber(var.gatekeeper.audit_interval)
        constraintViolationsLimit    = tonumber(var.gatekeeper.violation_limit)
        auditMatchKindOnly           = var.gatekeeper.match_kind_enabled
        emitAuditEvents              = var.gatekeeper.emit_events_enabled
        auditEventsInvolvedNamespace = var.gatekeeper.namespace_events_enabled
        enableExternalData           = var.gatekeeper.external_data_enabled
      }
    )
  ]
}
