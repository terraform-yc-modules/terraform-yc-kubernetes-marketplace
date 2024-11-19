# variables
variable "install_gitlab_runner" {
  description = "Install Gitlab Runner"
  type        = bool
  default     = false
}

variable "gitlab_runner" {
  description = "Map for overriding Gitlab Runner Helm chart settings"
  type = object({
    name       = optional(string)
    repository = optional(string)
    chart      = optional(string)
    version    = optional(string)
    namespace  = optional(string)

    gitlab_domain       = optional(string)
    gitlab_token        = optional(string)
    runner_privileged   = optional(bool)
    runner_tags         = optional(string)
  })
  default = {}
}

# locals
locals {
  default_gitlab_runner = {
    name              = "gitlab-runner"
    repository        = "oci://cr.yandex/yc-marketplace/yandex-cloud/gitlab-org/gitlab-runner/chart"
    chart             = "gitlab-runner"
    version           = "0.54.0-8"
    namespace         = "gitlab-runner"
    
    gitlab_domain       = null
    gitlab_token        = null
    runner_privileged   = false
    runner_tags         = null
  }

  gitlab_runner = merge(
    local.default_gitlab_runner,
    { for k, v in var.gitlab_runner : k => v if v != null }
  )
}

# helm
resource "helm_release" "gitlab_runner" {
  count       = var.install_gitlab_runner ? 1 : 0

  name        = local.gitlab_runner.name
  repository  = local.gitlab_runner.repository
  chart       = local.gitlab_runner.chart
  version     = local.gitlab_runner.version
  namespace   = local.gitlab_runner.namespace

  create_namespace = true

  values = [ 
    yamlencode(
      {
        gitlabDomain = tostring(local.gitlab_runner.gitlab_domain)
        runnerRegistrationToken = tostring(local.gitlab_runner.gitlab_token)
        runners = {
            privileged = local.gitlab_runner.runner_privileged
            tags = tostring(local.gitlab_runner.runner_tags)
        }
      }
    ) 
  ]
}