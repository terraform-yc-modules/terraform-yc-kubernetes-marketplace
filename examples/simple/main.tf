module "helm_addons" {
  source = "../../"

  cluster_id = var.cluster_id

  install_nodelocal_dns = true
}
