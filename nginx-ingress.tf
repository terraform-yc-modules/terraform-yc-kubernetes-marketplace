# variables
variable "install_ingress_nginx" {
  description = "Install Ingress NGINX"
  type        = bool
  default     = false
}

variable "ingress_nginx" {
  description = "Map for overriding Ingress NGINX Helm chart settings"
  type = object({
    name       = optional(string)
    repository = optional(string)
    chart      = optional(string)
    version    = optional(string)
    namespace  = optional(string)

    replica_count                       = optional(number)
    service_loadbalancer_ip             = optional(string)
    service_external_traffic_policy     = optional(string)
  })
  default = {}
}

# locals
locals {
  default_ingress_nginx = {
    name              = "ingress-nginx"
    repository        = "oci://cr.yandex/yc-marketplace/yandex-cloud/ingress-nginx/chart/"
    chart             = "ingress-nginx"
    version           = "4.10.0"
    namespace         = "ingress-nginx"

    replica_count                       = 1
    service_loadbalancer_ip             = null
    service_external_traffic_policy     = "Cluster" # Cluster or Local
  }

  ingress_nginx = merge(
    local.default_ingress_nginx,
    { for k, v in var.ingress_nginx : k => v if v != null }
  )
}

# helm
resource "helm_release" "ingress_nginx" {
  count       = var.install_ingress_nginx ? 1 : 0

  name        = local.ingress_nginx.name
  repository  = local.ingress_nginx.repository
  chart       = local.ingress_nginx.chart
  version     = local.ingress_nginx.version
  namespace   = local.ingress_nginx.namespace

  create_namespace = true

  values = [ 
    yamlencode(
      {
        controller = {
            replicaCount = tonumber(local.ingress_nginx.replica_count)
            service = {
                loadBalancerIP = tostring(local.ingress_nginx.service_loadbalancer_ip)
                externalTrafficPolicy = tostring(local.ingress_nginx.service_external_traffic_policy)
            }
        }
      }
    ) 
  ]
}