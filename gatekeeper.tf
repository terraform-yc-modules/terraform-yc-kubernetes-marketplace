# variables
variable "install_gatekeeper" {
  description = "Install Gatekeeper"
  type        = bool
  default     = false
}

variable "gatekeeper" {
  description = "Map for overriding Gatekeeper Helm chart settings"
  type = object({
    name       = optional(string)
    repository = optional(string)
    chart      = optional(string)
    version    = optional(string)
    namespace  = optional(string)

    audit_interval              = optional(number)
    violation_limit             = optional(number)
    match_kind_enabled          = optional(bool)
    emit_events_enabled         = optional(bool)
    namespace_events_enabled    = optional(bool)
    external_data_enabled       = optional(bool)
  })
  default = {}
}

# locals
locals {
  default_gatekeeper = {
    name              = "gatekeeper"
    repository        = "oci://cr.yandex/yc-marketplace"
    chart             = "gatekeeper"
    version           = "3.12.0"
    namespace         = "gatekeeper"
    
    audit_interval              = 60
    violation_limit             = 20
    match_kind_enabled          = false
    emit_events_enabled         = false
    namespace_events_enabled    = false
    external_data_enabled       = false
  }

  gatekeeper = merge(
    local.default_gatekeeper,
    { for k, v in var.gatekeeper : k => v if v != null }
  )
}

# helm
resource "helm_release" "gatekeeper" {
  count       = var.install_gatekeeper ? 1 : 0

  name        = local.gatekeeper.name
  repository  = local.gatekeeper.repository
  chart       = local.gatekeeper.chart
  version     = local.gatekeeper.version
  namespace   = local.gatekeeper.namespace

  create_namespace = true

  values = [ 
    yamlencode(
      {
        auditInterval = tonumber(local.gatekeeper.audit_interval)
        constraintViolationsLimit = tonumber(local.gatekeeper.violation_limit)
        auditMatchKindOnly = local.gatekeeper.match_kind_enabled
        emitAuditEvents = local.gatekeeper.emit_events_enabled
        auditEventsInvolvedNamespace = local.gatekeeper.namespace_events_enabled
        enableExternalData = local.gatekeeper.external_data_enabled
      }
    ) 
  ]
}