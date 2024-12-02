# variables
variable "install_ingress_nginx" {
  description = "Install Ingress NGINX"
  type        = bool
  default     = false
}

variable "ingress_nginx" {
  description = "Map for overriding Ingress NGINX Helm chart settings"
  type = object({
    name       = optional(string, "ingress-nginx")
    repository = optional(string, "oci://cr.yandex/yc-marketplace/yandex-cloud/ingress-nginx/chart/")
    chart      = optional(string, "ingress-nginx")
    version    = optional(string, "4.10.0")
    namespace  = optional(string, "ingress-nginx")

    replica_count                       = optional(number, 1)
    service_loadbalancer_ip             = optional(string)
    service_external_traffic_policy     = optional(string, "Cluster") # Cluster or Local
  })
  default = {}
}

# helm
resource "helm_release" "ingress_nginx" {
  count       = var.install_ingress_nginx ? 1 : 0

  name        = var.ingress_nginx.name
  repository  = var.ingress_nginx.repository
  chart       = var.ingress_nginx.chart
  version     = var.ingress_nginx.version
  namespace   = var.ingress_nginx.namespace

  create_namespace = true

  values = [ 
    yamlencode(
      {
        controller = {
            replicaCount = tonumber(var.ingress_nginx.replica_count)
            service = {
                loadBalancerIP = tostring(var.ingress_nginx.service_loadbalancer_ip)
                externalTrafficPolicy = tostring(var.ingress_nginx.service_external_traffic_policy)
            }
        }
      }
    ) 
  ]
}