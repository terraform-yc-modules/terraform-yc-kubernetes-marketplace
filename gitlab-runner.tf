# variables
variable "install_gitlab_runner" {
  description = "Install Gitlab Runner"
  type        = bool
  default     = false
}

variable "gitlab_runner" {
  description = "Map for overriding Gitlab Runner Helm chart settings"
  type = object({
    name       = optional(string, "gitlab-runner")
    repository = optional(string, "oci://cr.yandex/yc-marketplace/yandex-cloud/gitlab-org/gitlab-runner/chart")
    chart      = optional(string, "gitlab-runner")
    version    = optional(string, "0.54.0-8")
    namespace  = optional(string, "gitlab-runner")

    gitlab_domain     = optional(string)
    gitlab_token      = optional(string)
    runner_privileged = optional(bool, false)
    runner_tags       = optional(string)
  })
  default = {}
}

# helm
resource "helm_release" "gitlab_runner" {
  count = var.install_gitlab_runner ? 1 : 0

  name       = var.gitlab_runner.name
  repository = var.gitlab_runner.repository
  chart      = var.gitlab_runner.chart
  version    = var.gitlab_runner.version
  namespace  = var.gitlab_runner.namespace

  create_namespace = true

  values = [
    yamlencode(
      {
        gitlabDomain            = tostring(var.gitlab_runner.gitlab_domain)
        runnerRegistrationToken = tostring(var.gitlab_runner.gitlab_token)
        runners = {
          privileged = var.gitlab_runner.runner_privileged
          tags       = tostring(var.gitlab_runner.runner_tags)
        }
      }
    )
  ]
}
