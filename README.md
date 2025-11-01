# Kubernetes Marketplace Terraform Module for Yandex Cloud

## Features

- Install Yandex Cloud Marketplace for Kubernetes listed products using the Helm charts provided
- Define custom settings supported by the Helm charts

### Example Usage

```hcl-terraform
module "helm_addons" {
  source = "./"

  cluster_id = "k8s_cluster_id"

  install_nodelocal_dns = true
}
```

### Important

There might be a problem after deploying if the Kubernetes cluster being replaced. Helm Marketplace module will "block" the cluster change, if used in the same `terraform apply` cycle, as Helm provider won't be able to connect to the target Kubernetes cluster during refresh.
In that case, applying the change in two steps will help:
```bash
# First updating the initial Kubernetes cluster and replacing it
terraform apply -target=module.kube
# Applying all the rest, including Marketplace module
terraform apply
```
If the cluster changed in a separate (outside) module, but Marketplace won't apply because of outdated information, a simple refresh usually does the trick (after verifying that the `cluster_id` is valid):
```
terraform apply -refresh-only
```

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0 |
| <a name="requirement_helm"></a> [helm](#requirement\_helm) | >= 2.9, < 3.0 |
| <a name="requirement_yandex"></a> [yandex](#requirement\_yandex) | >= 0.108 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_helm"></a> [helm](#provider\_helm) | 2.17.0 |
| <a name="provider_yandex"></a> [yandex](#provider\_yandex) | 0.140.1 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [helm_release.alb_ingress](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [helm_release.argocd](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [helm_release.cert_manager](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [helm_release.chaos_mesh](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [helm_release.crossplane](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [helm_release.csi_s3](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [helm_release.external_dns](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [helm_release.external_secrets](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [helm_release.falco](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [helm_release.filebeat](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [helm_release.filebeat_oss](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [helm_release.fluentbit](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [helm_release.gatekeeper](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [helm_release.gateway_api](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [helm_release.gitlab_agent](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [helm_release.gitlab_runner](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [helm_release.ingress_nginx](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [helm_release.istio](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [helm_release.kruise](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [helm_release.kyverno](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [helm_release.loki](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [helm_release.metrics_provider](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [helm_release.nodelocal_dns](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [helm_release.policy_reporter](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [helm_release.prometheus](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [helm_release.vault](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [helm_release.velero](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [yandex_client_config.client](https://registry.terraform.io/providers/yandex-cloud/yandex/latest/docs/data-sources/client_config) | data source |
| [yandex_kubernetes_cluster.target](https://registry.terraform.io/providers/yandex-cloud/yandex/latest/docs/data-sources/kubernetes_cluster) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_alb_ingress"></a> [alb\_ingress](#input\_alb\_ingress) | Map for overriding ALB Ingress Controller Helm chart settings | <pre>object({<br/>    name       = optional(string, "alb-ingress")<br/>    repository = optional(string, "oci://cr.yandex/yc-marketplace/yandex-cloud/yc-alb-ingress")<br/>    chart      = optional(string, "yc-alb-ingress-controller-chart")<br/>    version    = optional(string, "v0.2.23")<br/>    namespace  = optional(string, "alb-ingress")<br/><br/>    folder_id            = optional(string, null)<br/>    cluster_id           = optional(string, null)<br/>    service_account_key  = optional(string, null)<br/>    healthchecks_enabled = optional(bool, false)<br/>  })</pre> | `{}` | no |
| <a name="input_argocd"></a> [argocd](#input\_argocd) | Map for overriding ArgoCD Helm chart settings | <pre>object({<br/>    name       = optional(string, "argocd")<br/>    repository = optional(string, "oci://cr.yandex/yc-marketplace/yandex-cloud/argo/chart")<br/>    chart      = optional(string, "argo-cd")<br/>    version    = optional(string, "7.3.11-2")<br/>    namespace  = optional(string, "argocd")<br/>  })</pre> | `{}` | no |
| <a name="input_cert_manager"></a> [cert\_manager](#input\_cert\_manager) | Map for overriding cert-manager Helm chart settings | <pre>object({<br/>    name       = optional(string, "cert-manager")<br/>    repository = optional(string, "oci://cr.yandex/yc-marketplace/yandex-cloud/cert-manager-webhook-yandex")<br/>    chart      = optional(string, "cert-manager-webhook-yandex")<br/>    version    = optional(string, "1.0.8-1")<br/>    namespace  = optional(string, "cert-manager")<br/><br/>    service_account_key = optional(string)<br/>    folder_id           = optional(string)<br/>    email_address       = optional(string)<br/>    letsencrypt_server  = optional(string, "https://acme-staging-v02.api.letsencrypt.org/directory")<br/>  })</pre> | `{}` | no |
| <a name="input_chaos_mesh"></a> [chaos\_mesh](#input\_chaos\_mesh) | Map for overriding Chaos Mesh Helm chart settings | <pre>object({<br/>    name       = optional(string, "chaos-mesh")<br/>    repository = optional(string, "oci://cr.yandex/yc-marketplace/yandex-cloud/chaos-mesh")<br/>    chart      = optional(string, "chaos-mesh")<br/>    version    = optional(string, "2.6.1-1b")<br/>    namespace  = optional(string, "chaos-mesh")<br/>  })</pre> | `{}` | no |
| <a name="input_cluster_id"></a> [cluster\_id](#input\_cluster\_id) | The ID of the Kubernetes cluster where addons should be installed. | `string` | n/a | yes |
| <a name="input_crossplane"></a> [crossplane](#input\_crossplane) | Map for overriding Crossplane Helm chart settings | <pre>object({<br/>    name       = optional(string, "crossplane")<br/>    repository = optional(string, "oci://cr.yandex/yc-marketplace/yandex-cloud/crossplane")<br/>    chart      = optional(string, "crossplane")<br/>    version    = optional(string, "v1.18.2")<br/>    namespace  = optional(string, "crossplane")<br/><br/>    service_account_key = optional(string)<br/>  })</pre> | `{}` | no |
| <a name="input_csi_s3"></a> [csi\_s3](#input\_csi\_s3) | Map for overriding CSI S3 Helm chart settings | <pre>object({<br/>    name       = optional(string, "csi-s3")<br/>    repository = optional(string, "oci://cr.yandex/yc-marketplace/yandex-cloud/csi-s3")<br/>    chart      = optional(string, "csi-s3")<br/>    version    = optional(string, "0.42.1")<br/>    namespace  = optional(string, "csi-s3")<br/><br/>    create_storage_class      = optional(bool, true)<br/>    create_secret             = optional(bool, true)<br/>    object_storage_key_id     = optional(string)<br/>    object_storage_key_secret = optional(string)<br/>    single_bucket             = optional(string)<br/>    s3_endpoint               = optional(string, "https://storage.yandexcloud.net")<br/>    s3_region                 = optional(string, "ru-central1")<br/>    mount_options             = optional(string, "--memory-limit 1000 --dir-mode 0777 --file-mode 0666")<br/>    reclaim_policy            = optional(string, "Delete")<br/>    storage_class_name        = optional(string, "csi-s3")<br/>    secret_name               = optional(string, "csi-s3-secret")<br/>    tolerations_all           = optional(bool, false)<br/>  })</pre> | `{}` | no |
| <a name="input_external_dns"></a> [external\_dns](#input\_external\_dns) | Map for overriding External DNS Helm chart settings | <pre>object({<br/>    name       = optional(string, "external-dns")<br/>    repository = optional(string, "oci://cr.yandex/yc-marketplace/yandex-cloud/externaldns/chart/")<br/>    chart      = optional(string, "externaldns")<br/>    version    = optional(string, "0.5.1-b")<br/>    namespace  = optional(string, "external-dns")<br/><br/>    service_account_key = optional(string)<br/>    folder_id           = optional(string)<br/>  })</pre> | `{}` | no |
| <a name="input_external_secrets"></a> [external\_secrets](#input\_external\_secrets) | Map for overriding External Secrets Helm chart settings | <pre>object({<br/>    name       = optional(string, "external-secrets")<br/>    repository = optional(string, "oci://cr.yandex/yc-marketplace/yandex-cloud/external-secrets/chart")<br/>    chart      = optional(string, "external-secrets")<br/>    version    = optional(string, "0.10.5")<br/>    namespace  = optional(string, "external-secrets")<br/><br/>    service_account_key = optional(string)<br/>  })</pre> | `{}` | no |
| <a name="input_falco"></a> [falco](#input\_falco) | Map for overriding Falco Helm chart settings | <pre>object({<br/>    name       = optional(string, "falco")<br/>    repository = optional(string, "oci://cr.yandex/yc-marketplace")<br/>    chart      = optional(string, "falco")<br/>    version    = optional(string, "2.2.5")<br/>    namespace  = optional(string, "falco")<br/><br/>    falco_sidekick_enabled      = optional(bool, false)<br/>    falco_sidekick_replicacount = optional(number, 1)<br/>  })</pre> | `{}` | no |
| <a name="input_filebeat"></a> [filebeat](#input\_filebeat) | Map for overriding Filebeat Helm chart settings | <pre>object({<br/>    name       = optional(string, "filebeat")<br/>    repository = optional(string, "oci://cr.yandex/yc-marketplace/yandex-cloud/filebeat/chart")<br/>    chart      = optional(string, "filebeat")<br/>    version    = optional(string, "7.16.3-5")<br/>    namespace  = optional(string, "filebeat")<br/><br/>    elasticsearch_username = optional(string, "admin")<br/>    elasticsearch_password = optional(string)<br/>    elasticsearch_fqdn     = optional(string)<br/>  })</pre> | `{}` | no |
| <a name="input_filebeat_oss"></a> [filebeat\_oss](#input\_filebeat\_oss) | Map for overriding Filebeat OSS Helm chart settings | <pre>object({<br/>    name       = optional(string, "filebeat")<br/>    repository = optional(string, "oci://cr.yandex/yc-marketplace/yandex-cloud/filebeat-oss/chart")<br/>    chart      = optional(string, "filebeat-oss")<br/>    version    = optional(string, "7.12.1-1")<br/>    namespace  = optional(string, "filebeat")<br/><br/>    opensearch_username = optional(string, "admin")<br/>    opensearch_password = optional(string)<br/>    opensearch_fqdn     = optional(string)<br/>  })</pre> | `{}` | no |
| <a name="input_fluentbit"></a> [fluentbit](#input\_fluentbit) | Map for overriding Fluentbit Helm chart settings | <pre>object({<br/>    name       = optional(string, "fluent-bit")<br/>    repository = optional(string, "oci://cr.yandex/yc-marketplace/yandex-cloud/fluent-bit")<br/>    chart      = optional(string, "fluent-bit")<br/>    version    = optional(string, "2.1.7-3")<br/>    namespace  = optional(string, "fluent-bit")<br/><br/>    log_group_id              = optional(string)<br/>    service_account_key       = optional(string)<br/>    export_to_s3_enabled      = optional(bool, false)<br/>    object_storage_bucket     = optional(string)<br/>    object_storage_key_id     = optional(string)<br/>    object_storage_key_secret = optional(string)<br/>  })</pre> | `{}` | no |
| <a name="input_gatekeeper"></a> [gatekeeper](#input\_gatekeeper) | Map for overriding Gatekeeper Helm chart settings | <pre>object({<br/>    name       = optional(string, "gatekeeper")<br/>    repository = optional(string, "oci://cr.yandex/yc-marketplace")<br/>    chart      = optional(string, "gatekeeper")<br/>    version    = optional(string, "3.12.0")<br/>    namespace  = optional(string, "gatekeeper")<br/><br/>    audit_interval           = optional(number, 60)<br/>    violation_limit          = optional(number, 20)<br/>    match_kind_enabled       = optional(bool, false)<br/>    emit_events_enabled      = optional(bool, false)<br/>    namespace_events_enabled = optional(bool, false)<br/>    external_data_enabled    = optional(bool, false)<br/>  })</pre> | `{}` | no |
| <a name="input_gateway_api"></a> [gateway\_api](#input\_gateway\_api) | Map for overriding Gateway API Helm chart settings | <pre>object({<br/>    name       = optional(string, "gateway-api")<br/>    repository = optional(string, "oci://cr.yandex/yc-marketplace/yandex-cloud/gateway-api/gateway-api-helm")<br/>    chart      = optional(string, "gateway-api")<br/>    version    = optional(string, "0.6.0")<br/>    namespace  = optional(string, "gateway-api")<br/><br/>    folder_id           = optional(string)<br/>    vpc_network_id      = optional(string)<br/>    subnet_id_a         = optional(string)<br/>    subnet_id_b         = optional(string)<br/>    subnet_id_d         = optional(string)<br/>    service_account_key = optional(string)<br/>  })</pre> | `{}` | no |
| <a name="input_gitlab_agent"></a> [gitlab\_agent](#input\_gitlab\_agent) | Map for overriding Gitlab Agent Helm chart settings | <pre>object({<br/>    name       = optional(string, "gitlab-agent")<br/>    repository = optional(string, "oci://cr.yandex/yc-marketplace/yandex-cloud/gitlab-org/gitlab-agent/chart")<br/>    chart      = optional(string, "gitlab-agent")<br/>    version    = optional(string, "1.16.0-1")<br/>    namespace  = optional(string, "gitlab-agent")<br/><br/>    gitlab_domain = optional(string)<br/>    gitlab_token  = optional(string)<br/>  })</pre> | `{}` | no |
| <a name="input_gitlab_runner"></a> [gitlab\_runner](#input\_gitlab\_runner) | Map for overriding Gitlab Runner Helm chart settings | <pre>object({<br/>    name       = optional(string, "gitlab-runner")<br/>    repository = optional(string, "oci://cr.yandex/yc-marketplace/yandex-cloud/gitlab-org/gitlab-runner/chart")<br/>    chart      = optional(string, "gitlab-runner")<br/>    version    = optional(string, "0.54.0-8")<br/>    namespace  = optional(string, "gitlab-runner")<br/><br/>    gitlab_domain     = optional(string)<br/>    gitlab_token      = optional(string)<br/>    runner_privileged = optional(bool, false)<br/>    runner_tags       = optional(string)<br/>  })</pre> | `{}` | no |
| <a name="input_ingress_nginx"></a> [ingress\_nginx](#input\_ingress\_nginx) | Map for overriding Ingress NGINX Helm chart settings | <pre>object({<br/>    name       = optional(string, "ingress-nginx")<br/>    repository = optional(string, "oci://cr.yandex/yc-marketplace/yandex-cloud/ingress-nginx/chart/")<br/>    chart      = optional(string, "ingress-nginx")<br/>    version    = optional(string, "4.12.1")<br/>    namespace  = optional(string, "ingress-nginx")<br/><br/>    ingress_class_name              = optional(string, "nginx")<br/>    replica_count                   = optional(number, 1)<br/>    service_loadbalancer_ip         = optional(string)<br/>    service_external_traffic_policy = optional(string, "Cluster") # Cluster or Local<br/>    service_session_affinity        = optional(string, "None")    # None or ClientIP<br/>  })</pre> | `{}` | no |
| <a name="input_install_alb_ingress"></a> [install\_alb\_ingress](#input\_install\_alb\_ingress) | Install ALB Ingress Controller | `bool` | `false` | no |
| <a name="input_install_argocd"></a> [install\_argocd](#input\_install\_argocd) | Install ArgoCD | `bool` | `false` | no |
| <a name="input_install_cert_manager"></a> [install\_cert\_manager](#input\_install\_cert\_manager) | Install cert-manager | `bool` | `false` | no |
| <a name="input_install_chaos_mesh"></a> [install\_chaos\_mesh](#input\_install\_chaos\_mesh) | Install Chaos Mesh | `bool` | `false` | no |
| <a name="input_install_crossplane"></a> [install\_crossplane](#input\_install\_crossplane) | Install Crossplane | `bool` | `false` | no |
| <a name="input_install_csi_s3"></a> [install\_csi\_s3](#input\_install\_csi\_s3) | Install CSI S3 | `bool` | `false` | no |
| <a name="input_install_external_dns"></a> [install\_external\_dns](#input\_install\_external\_dns) | Install External DNS | `bool` | `false` | no |
| <a name="input_install_external_secrets"></a> [install\_external\_secrets](#input\_install\_external\_secrets) | Install External Secrets | `bool` | `false` | no |
| <a name="input_install_falco"></a> [install\_falco](#input\_install\_falco) | Install Falco | `bool` | `false` | no |
| <a name="input_install_filebeat"></a> [install\_filebeat](#input\_install\_filebeat) | Install Filebeat | `bool` | `false` | no |
| <a name="input_install_filebeat_oss"></a> [install\_filebeat\_oss](#input\_install\_filebeat\_oss) | Install Filebeat OSS | `bool` | `false` | no |
| <a name="input_install_fluentbit"></a> [install\_fluentbit](#input\_install\_fluentbit) | Install Fluentbit | `bool` | `false` | no |
| <a name="input_install_gatekeeper"></a> [install\_gatekeeper](#input\_install\_gatekeeper) | Install Gatekeeper | `bool` | `false` | no |
| <a name="input_install_gateway_api"></a> [install\_gateway\_api](#input\_install\_gateway\_api) | Install Gateway API | `bool` | `false` | no |
| <a name="input_install_gitlab_agent"></a> [install\_gitlab\_agent](#input\_install\_gitlab\_agent) | Install Gitlab Agent | `bool` | `false` | no |
| <a name="input_install_gitlab_runner"></a> [install\_gitlab\_runner](#input\_install\_gitlab\_runner) | Install Gitlab Runner | `bool` | `false` | no |
| <a name="input_install_ingress_nginx"></a> [install\_ingress\_nginx](#input\_install\_ingress\_nginx) | Install Ingress NGINX | `bool` | `false` | no |
| <a name="input_install_istio"></a> [install\_istio](#input\_install\_istio) | Install Istio | `bool` | `false` | no |
| <a name="input_install_kruise"></a> [install\_kruise](#input\_install\_kruise) | Install Kruise | `bool` | `false` | no |
| <a name="input_install_kyverno"></a> [install\_kyverno](#input\_install\_kyverno) | Install Kyverno | `bool` | `false` | no |
| <a name="input_install_loki"></a> [install\_loki](#input\_install\_loki) | Install Loki | `bool` | `false` | no |
| <a name="input_install_metrics_provider"></a> [install\_metrics\_provider](#input\_install\_metrics\_provider) | Install Metrics Provider | `bool` | `false` | no |
| <a name="input_install_nodelocal_dns"></a> [install\_nodelocal\_dns](#input\_install\_nodelocal\_dns) | Install NodeLocal NS | `bool` | `false` | no |
| <a name="input_install_policy_reporter"></a> [install\_policy\_reporter](#input\_install\_policy\_reporter) | Install Policy Reporter | `bool` | `false` | no |
| <a name="input_install_prometheus"></a> [install\_prometheus](#input\_install\_prometheus) | Install Prometheus | `bool` | `false` | no |
| <a name="input_install_vault"></a> [install\_vault](#input\_install\_vault) | Install Vault | `bool` | `false` | no |
| <a name="input_install_velero"></a> [install\_velero](#input\_install\_velero) | Install Velero | `bool` | `false` | no |
| <a name="input_istio"></a> [istio](#input\_istio) | Map for overriding Istio Helm chart settings | <pre>object({<br/>    name       = optional(string, "istio")<br/>    repository = optional(string, "oci://cr.yandex/yc-marketplace/yandex-cloud/istio")<br/>    chart      = optional(string, "istio")<br/>    version    = optional(string, "1.21.2-1")<br/>    namespace  = optional(string, "istio-system")<br/><br/>    addons_enabled = optional(bool, false)<br/>  })</pre> | `{}` | no |
| <a name="input_kruise"></a> [kruise](#input\_kruise) | Map for overriding Kruise Helm chart settings | <pre>object({<br/>    name       = optional(string, "kruise")<br/>    repository = optional(string, "oci://cr.yandex/yc-marketplace/yandex-cloud/kruise/chart")<br/>    chart      = optional(string, "kruise")<br/>    version    = optional(string, "1.5.0")<br/>    namespace  = optional(string, "kruise")<br/>  })</pre> | `{}` | no |
| <a name="input_kyverno"></a> [kyverno](#input\_kyverno) | Map for overriding Kyverno Helm chart settings | <pre>object({<br/>    name       = optional(string, "kyverno")<br/>    repository = optional(string, "oci://cr.yandex/yc-marketplace")<br/>    chart      = optional(string, "multi-kyverno")<br/>    version    = optional(string, "1.0.0")<br/>    namespace  = optional(string, "kyverno")<br/><br/>    kyverno_policies_enabled = optional(bool, true)<br/>    pod_security_profile     = optional(string, "baseline")<br/>    failure_action           = optional(string, "audit") # audit, enforce<br/>  })</pre> | `{}` | no |
| <a name="input_loki"></a> [loki](#input\_loki) | Map for overriding Loki Helm chart settings | <pre>object({<br/>    name       = optional(string, "loki")<br/>    repository = optional(string, "oci://cr.yandex/yc-marketplace/yandex-cloud/grafana/loki/chart")<br/>    chart      = optional(string, "loki")<br/>    version    = optional(string, "1.2.0-7")<br/>    namespace  = optional(string, "loki")<br/><br/>    object_storage_bucket = optional(string)<br/>    aws_key_value         = optional(string)<br/>    promtail_enabled      = optional(bool, true)<br/>  })</pre> | `{}` | no |
| <a name="input_metrics_provider"></a> [metrics\_provider](#input\_metrics\_provider) | Map for overriding Metrics Provider Helm chart settings | <pre>object({<br/>    name       = optional(string, "metrics-provider")<br/>    repository = optional(string, "oci://cr.yandex/yc-marketplace/yandex-cloud/metric-provider/chart")<br/>    chart      = optional(string, "metrics-provider")<br/>    version    = optional(string, "0.1.13")<br/>    namespace  = optional(string, "metrics-provider")<br/><br/>    metrics_folder_id             = optional(string)<br/>    metrics_window                = optional(string, "2m")<br/>    downsampling_disabled         = optional(bool, true)<br/>    downsampling_grid_aggregation = optional(string, "AVG")<br/>    downsampling_gap_filling      = optional(string, "PREVIOUS")<br/>    downsampling_gap_max_points   = optional(number, 10)<br/>    downsampling_grid_interval    = optional(number, 1)<br/>    service_account_key           = optional(string)<br/>  })</pre> | `{}` | no |
| <a name="input_nodelocal_dns"></a> [nodelocal\_dns](#input\_nodelocal\_dns) | Map for overriding NodeLocal DNS Helm chart settings | <pre>object({<br/>    name       = optional(string, "node-local-dns")<br/>    repository = optional(string, "oci://cr.yandex/yc-marketplace/yandex-cloud")<br/>    chart      = optional(string, "node-local-dns")<br/>    version    = optional(string, "1.5.1")<br/>    namespace  = optional(string, "node-local-dns")<br/>  })</pre> | `{}` | no |
| <a name="input_policy_reporter"></a> [policy\_reporter](#input\_policy\_reporter) | Map for overriding Policy Reporter Helm chart settings | <pre>object({<br/>    name       = optional(string, "policy-reporter")<br/>    repository = optional(string, "oci://cr.yandex/yc-marketplace")<br/>    chart      = optional(string, "policy-reporter")<br/>    version    = optional(string, "2.13.11")<br/>    namespace  = optional(string, "policy-reporter")<br/><br/>    cluster_id            = optional(string)<br/>    custom_fields_enabled = optional(bool, false)<br/>    ui_enabled            = optional(bool, false)<br/>    s3_enabled            = optional(bool, false)<br/>    s3_bucket             = optional(string)<br/>    kinesis_enabled       = optional(bool, false)<br/>    kinesis_endpoint      = optional(string)<br/>    kinesis_stream        = optional(string)<br/>    aws_key_value         = optional(string)<br/>  })</pre> | `{}` | no |
| <a name="input_prometheus"></a> [prometheus](#input\_prometheus) | Map for overriding Prometheus Helm chart settings | <pre>object({<br/>    name       = optional(string, "prometheus")<br/>    repository = optional(string, "oci://cr.yandex/yc-marketplace/yandex-cloud/prometheus")<br/>    chart      = optional(string, "kube-prometheus-stack")<br/>    version    = optional(string, "57.2.0-1")<br/>    namespace  = optional(string, "prometheus")<br/><br/>    prometheus_workspace_id = optional(string)<br/>    api_key_value           = optional(string)<br/>  })</pre> | `{}` | no |
| <a name="input_vault"></a> [vault](#input\_vault) | Map for overriding Vault Helm chart settings | <pre>object({<br/>    name       = optional(string, "vault")<br/>    repository = optional(string, "oci://cr.yandex/yc-marketplace/yandex-cloud/vault/chart")<br/>    chart      = optional(string, "vault")<br/>    version    = optional(string, "0.29.0_yckms")<br/>    namespace  = optional(string, "vault")<br/><br/>    service_account_key = optional(string)<br/>    kms_key_id          = optional(string)<br/>  })</pre> | `{}` | no |
| <a name="input_velero"></a> [velero](#input\_velero) | Map for overriding Velero Helm chart settings | <pre>object({<br/>    name       = optional(string, "velero")<br/>    repository = optional(string, "oci://cr.yandex/yc-marketplace/yandex-cloud/velero")<br/>    chart      = optional(string, "velero")<br/>    version    = optional(string, "8.5.0-5")<br/>    namespace  = optional(string, "velero")<br/><br/>    object_storage_bucket = optional(string)<br/>    aws_key_value         = optional(string)<br/>  })</pre> | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_alb_ingress_status"></a> [alb\_ingress\_status](#output\_alb\_ingress\_status) | ALB Ingress deployment status. |
| <a name="output_argocd_status"></a> [argocd\_status](#output\_argocd\_status) | ArgoCD deployment status. |
| <a name="output_cert_manager_status"></a> [cert\_manager\_status](#output\_cert\_manager\_status) | cert-manager deployment status. |
| <a name="output_chaos_mesh_status"></a> [chaos\_mesh\_status](#output\_chaos\_mesh\_status) | Chaos Mesh deployment status. |
| <a name="output_cluster_id"></a> [cluster\_id](#output\_cluster\_id) | Kubernetes cluster ID. |
| <a name="output_crossplane_status"></a> [crossplane\_status](#output\_crossplane\_status) | Crossplane deployment status. |
| <a name="output_csi_s3_status"></a> [csi\_s3\_status](#output\_csi\_s3\_status) | CSI S3 deployment status. |
| <a name="output_external_dns_status"></a> [external\_dns\_status](#output\_external\_dns\_status) | External DNS deployment status. |
| <a name="output_external_secrets_status"></a> [external\_secrets\_status](#output\_external\_secrets\_status) | External Secrets deployment status. |
| <a name="output_falco_status"></a> [falco\_status](#output\_falco\_status) | Falco deployment status. |
| <a name="output_filebeat_oss_status"></a> [filebeat\_oss\_status](#output\_filebeat\_oss\_status) | Filebeat OSS deployment status. |
| <a name="output_filebeat_status"></a> [filebeat\_status](#output\_filebeat\_status) | Filebeat deployment status. |
| <a name="output_fluentbit_status"></a> [fluentbit\_status](#output\_fluentbit\_status) | Fluentbit deployment status. |
| <a name="output_gatekeeper_status"></a> [gatekeeper\_status](#output\_gatekeeper\_status) | Gatekeeper deployment status. |
| <a name="output_gateway_api_status"></a> [gateway\_api\_status](#output\_gateway\_api\_status) | Gateway API deployment status. |
| <a name="output_gitlab_agent_status"></a> [gitlab\_agent\_status](#output\_gitlab\_agent\_status) | Gitlab Agent deployment status. |
| <a name="output_gitlab_runner_status"></a> [gitlab\_runner\_status](#output\_gitlab\_runner\_status) | Gitlab Runner deployment status. |
| <a name="output_ingress_nginx_status"></a> [ingress\_nginx\_status](#output\_ingress\_nginx\_status) | NGINX Ingress deployment status. |
| <a name="output_istio_status"></a> [istio\_status](#output\_istio\_status) | Istio deployment status. |
| <a name="output_kruise_status"></a> [kruise\_status](#output\_kruise\_status) | Kruise deployment status. |
| <a name="output_kyverno_status"></a> [kyverno\_status](#output\_kyverno\_status) | Kyverno deployment status. |
| <a name="output_loki_status"></a> [loki\_status](#output\_loki\_status) | Loki deployment status. |
| <a name="output_metrics_provider_status"></a> [metrics\_provider\_status](#output\_metrics\_provider\_status) | Metrics Provider deployment status. |
| <a name="output_nodelocal_dns_status"></a> [nodelocal\_dns\_status](#output\_nodelocal\_dns\_status) | Node-Local DNS deployment status. |
| <a name="output_policy_reporter_status"></a> [policy\_reporter\_status](#output\_policy\_reporter\_status) | Policy Reporter deployment status. |
| <a name="output_prometheus_status"></a> [prometheus\_status](#output\_prometheus\_status) | Prometheus deployment status. |
| <a name="output_vault_status"></a> [vault\_status](#output\_vault\_status) | Vault deployment status. |
| <a name="output_velero_status"></a> [velero\_status](#output\_velero\_status) | Velero deployment status. |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
