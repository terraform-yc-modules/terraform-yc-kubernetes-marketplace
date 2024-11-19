# variables
variable "install_gitlab_agent" {
  description = "Install Gitlab Agent"
  type        = bool
  default     = false
}

variable "gitlab_agent" {
  description = "Map for overriding Gitlab Agent Helm chart settings"
  type = object({
    name       = optional(string)
    repository = optional(string)
    chart      = optional(string)
    version    = optional(string)
    namespace  = optional(string)

    gitlab_domain = optional(string)
    gitlab_token  = optional(string)
  })
  default = {}
}

# locals
locals {
  default_gitlab_agent = {
    name              = "gitlab-agent"
    repository        = "oci://cr.yandex/yc-marketplace/yandex-cloud/gitlab-org/gitlab-agent/chart"
    chart             = "gitlab-agent"
    version           = "1.16.0-1"
    namespace         = "gitlab-agent"
    
    gitlab_domain       = null
    gitlab_token        = null
  }

  gitlab_agent = merge(
    local.default_gitlab_agent,
    { for k, v in var.gitlab_agent : k => v if v != null }
  )
}

# helm
resource "helm_release" "gitlab_agent" {
  count       = var.install_gitlab_agent ? 1 : 0

  name        = local.gitlab_agent.name
  repository  = local.gitlab_agent.repository
  chart       = local.gitlab_agent.chart
  version     = local.gitlab_agent.version
  namespace   = local.gitlab_agent.namespace

  create_namespace = true

  values = [ 
    yamlencode(
      {
        gitlabDomain = tostring(local.gitlab_agent.gitlab_domain)
        config = {
            token = tostring(local.gitlab_agent.gitlab_token)
        }
      }
    ) 
  ]
}