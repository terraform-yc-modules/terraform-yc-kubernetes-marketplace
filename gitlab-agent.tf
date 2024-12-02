# variables
variable "install_gitlab_agent" {
  description = "Install Gitlab Agent"
  type        = bool
  default     = false
}

variable "gitlab_agent" {
  description = "Map for overriding Gitlab Agent Helm chart settings"
  type = object({
    name       = optional(string, "gitlab-agent")
    repository = optional(string, "oci://cr.yandex/yc-marketplace/yandex-cloud/gitlab-org/gitlab-agent/chart")
    chart      = optional(string, "gitlab-agent")
    version    = optional(string, "1.16.0-1")
    namespace  = optional(string, "gitlab-agent")

    gitlab_domain = optional(string)
    gitlab_token  = optional(string)
  })
  default = {}
}

# helm
resource "helm_release" "gitlab_agent" {
  count       = var.install_gitlab_agent ? 1 : 0

  name        = var.gitlab_agent.name
  repository  = var.gitlab_agent.repository
  chart       = var.gitlab_agent.chart
  version     = var.gitlab_agent.version
  namespace   = var.gitlab_agent.namespace

  create_namespace = true

  values = [ 
    yamlencode(
      {
        gitlabDomain = tostring(var.gitlab_agent.gitlab_domain)
        config = {
            token = tostring(var.gitlab_agent.gitlab_token)
        }
      }
    ) 
  ]
}