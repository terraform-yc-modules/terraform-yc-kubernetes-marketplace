# variables
variable "install_gateway_api" {
  description = "Install Gateway API"
  type        = bool
  default     = false
}

variable "gateway_api" {
  description = "Map for overriding Gateway API Helm chart settings"
  type = object({
    name       = optional(string, "gateway-api")
    repository = optional(string, "oci://cr.yandex/yc-marketplace/yandex-cloud/gateway-api/gateway-api-helm")
    chart      = optional(string, "gateway-api")
    version    = optional(string, "0.4.31")
    namespace  = optional(string, "gateway-api")

    folder_id           = optional(string)
    vpc_network_id      = optional(string)
    subnet_id_a         = optional(string)
    subnet_id_b         = optional(string)
    subnet_id_d         = optional(string)
    service_account_key = optional(string)
  })
  default = {}
}

# helm
resource "helm_release" "gateway_api" {
  count = var.install_gateway_api ? 1 : 0

  name       = var.gateway_api.name
  repository = var.gateway_api.repository
  chart      = var.gateway_api.chart
  version    = var.gateway_api.version
  namespace  = var.gateway_api.namespace

  create_namespace = true

  values = [
    yamlencode(
      {
        folderId       = tostring(var.gateway_api.folder_id)
        networkId      = tostring(var.gateway_api.vpc_network_id)
        subnet1Id      = tostring(var.gateway_api.subnet_id_a)
        subnet2Id      = tostring(var.gateway_api.subnet_id_b)
        subnet3Id      = tostring(var.gateway_api.subnet_id_d)
        saKeySecretKey = tostring(var.gateway_api.service_account_key)
      }
    )
  ]
}
