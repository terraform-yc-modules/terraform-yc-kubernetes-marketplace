# variables
variable "install_gateway_api" {
  description = "Install Gateway API"
  type        = bool
  default     = false
}

variable "gateway_api" {
  description = "Map for overriding Gateway API Helm chart settings"
  type = object({
    name       = optional(string)
    repository = optional(string)
    chart      = optional(string)
    version    = optional(string)
    namespace  = optional(string)

    folder_id               = optional(string)
    vpc_network_id          = optional(string)
    subnet_id_a             = optional(string)
    subnet_id_b             = optional(string)
    subnet_id_d             = optional(string)
    service_account_key     = optional(string)
  })
  default = {}
}

# locals
locals {
  default_gateway_api = {
    name              = "gateway-api"
    repository        = "oci://cr.yandex/yc-marketplace/yandex-cloud/gateway-api/gateway-api-helm"
    chart             = "gateway-api"
    version           = "0.4.31"
    namespace         = "gateway-api"
    
    folder_id               = null
    vpc_network_id          = null
    subnet_id_a             = null
    subnet_id_b             = null
    subnet_id_d             = null
    service_account_key     = null
  }

  gateway_api = merge(
    local.default_gateway_api,
    { for k, v in var.gateway_api : k => v if v != null }
  )
}

# helm
resource "helm_release" "gateway_api" {
  count       = var.install_gateway_api ? 1 : 0

  name        = local.gateway_api.name
  repository  = local.gateway_api.repository
  chart       = local.gateway_api.chart
  version     = local.gateway_api.version
  namespace   = local.gateway_api.namespace

  create_namespace = true

  values = [ 
    yamlencode(
      {
        folderId = tostring(local.gateway_api.folder_id)
        networkId = tostring(local.gateway_api.vpc_network_id)
        subnet1Id = tostring(local.gateway_api.subnet_id_a)
        subnet2Id = tostring(local.gateway_api.subnet_id_b)
        subnet3Id = tostring(local.gateway_api.subnet_id_d)
        saKeySecretKey = tostring(local.gateway_api.service_account_key)
      }
    ) 
  ]
}