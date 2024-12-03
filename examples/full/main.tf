module "helm_addons" {
  source = "../../"

  cluster_id = var.cluster_id

  install_alb_ingress      = false
  install_argocd           = false
  install_cert_manager     = false
  install_chaos_mesh       = false
  install_crossplane       = false
  install_csi_s3           = false
  install_external_dns     = false
  install_external_secrets = false
  install_falco            = false
  install_filebeat         = false
  install_filebeat_oss     = false
  install_fluentbit        = false
  install_gatekeeper       = false
  install_gateway_api      = false
  install_gitlab_agent     = false
  install_gitlab_runner    = false
  install_ingress_nginx    = false
  install_istio            = false
  install_kruise           = false
  install_kyverno          = false
  install_loki             = false
  install_metrics_provider = false
  install_nodelocal_dns    = false
  install_policy_reporter  = false
  install_prometheus       = false
  install_vault            = false
  install_velero           = false

  alb_ingress = {
    folder_id            = "xxx"
    cluster_id           = var.cluster_id
    service_account_key  = file("key.json")
    healthchecks_enabled = true
  }

  argocd = {}

  cert_manager = {
    service_account_key = file("key.json")
    folder_id           = "xxx"
    email_address       = "xxx"
  }

  chaos_mesh = {}

  crossplane = {
    service_account_key = file("key.json")
  }

  csi_s3 = {
    create_storage_class      = true
    create_secret             = true
    object_storage_key_id     = "id"
    object_storage_key_secret = "secret"
    single_bucket             = "bucket"
  }

  external_dns = {
    service_account_key = file("key.json")
    folder_id           = "xxx"
  }

  external_secrets = {
    service_account_key = file("key.json")
  }

  falco = {
    falco_sidekick_enabled      = true
    falco_sidekick_replicacount = 2
  }

  filebeat = {
    elasticsearch_username = "admin"
    elasticsearch_password = "password"
    elasticsearch_fqdn     = "https://elasticsearch-fqdn"
  }

  filebeat_oss = {
    opensearch_username = "admin"
    opensearch_password = "password"
    opensearch_fqdn     = "https://opensearch-fqdn"
  }

  fluentbit = {
    log_group_id              = "xxx"
    service_account_key       = file("key.json")
    export_to_s3_enabled      = true
    object_storage_bucket     = "bucket"
    object_storage_key_id     = "id"
    object_storage_key_secret = "secret"
  }

  gatekeeper = {
    audit_interval           = 60
    violation_limit          = 20
    match_kind_enabled       = false
    emit_events_enabled      = false
    namespace_events_enabled = false
    external_data_enabled    = false
  }

  gateway_api = {
    folder_id           = "xxx"
    vpc_network_id      = "xxx"
    subnet_id_a         = "xxx"
    subnet_id_b         = "xxx"
    subnet_id_d         = "xxx"
    service_account_key = file("key.json")
  }

  gitlab_agent = {
    gitlab_domain = "xxxxxx.gitlab.yandexcloud.net"
    gitlab_token  = "token"
  }

  gitlab_runner = {
    gitlab_domain     = "xxxxxx.gitlab.yandexcloud.net"
    gitlab_token      = "token"
    runner_privileged = true
    runner_tags       = "dev, test"
  }

  ingress_nginx = {
    replica_count = 1
    # service_loadbalancer_ip             = null
    # service_external_traffic_policy     = "Cluster" # Cluster or Local
  }

  istio = {
    addons_enabled = true
  }

  kruise = {}

  kyverno = {
    kyverno_policies_enabled = true
    pod_security_profile     = "baseline" # baseline, restricted, privileged
    failure_action           = "audit"    # audit, enforce
  }

  loki = {
    object_storage_bucket = "bucket"
    aws_key_value         = "json static key"
    promtail_enabled      = true
  }

  metrics_provider = {
    metrics_folder_id = "xxx"
    # metrics_window                  = "2m"
    # downsampling_disabled           = true
    # downsampling_grid_aggregation   = "AVG"
    # downsampling_gap_filling        = "PREVIOUS"
    # downsampling_gap_max_points     = 10
    # downsampling_grid_interval      = 1
    service_account_key = file("key.json")
  }

  nodelocal_dns = {}

  policy_reporter = {
    cluster_id            = var.cluster_id
    custom_fields_enabled = false
    ui_enabled            = false
    s3_enabled            = false
    s3_bucket             = "bucket"
    kinesis_enabled       = false
    kinesis_endpoint      = "endpoint"
    kinesis_stream        = "stream"
    aws_key_value         = "json-key"
  }

  prometheus = {
    api_key_value           = file("api-key.json")
    prometheus_workspace_id = "xxx"
  }

  vault = {
    service_account_key = file("key.json")
    kms_key_id          = "xxx"
  }

  velero = {
    aws_key_value         = "bucket"
    object_storage_bucket = "json static key"
  }
}
