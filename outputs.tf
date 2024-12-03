output "cluster_id" {
  description = "Kubernetes cluster ID."
  value       = try(data.yandex_kubernetes_cluster.target.id, null)
}

output "alb_ingress_status" {
  description = <<EOF
    ALB Ingress deployment status.
  EOF
  value       = try(helm_release.alb_ingress[0].status, "n/a")
}

output "argocd_status" {
  description = <<EOF
    ArgoCD deployment status.
  EOF
  value       = try(helm_release.argocd[0].status, "n/a")
}

output "cert_manager_status" {
  description = <<EOF
    cert-manager deployment status.
  EOF
  value       = try(helm_release.cert_manager[0].status, "n/a")
}

output "chaos_mesh_status" {
  description = <<EOF
    Chaos Mesh deployment status.
  EOF
  value       = try(helm_release.chaos_mesh[0].status, "n/a")
}

output "crossplane_status" {
  description = <<EOF
    Crossplane deployment status.
  EOF
  value       = try(helm_release.crossplane[0].status, "n/a")
}

output "csi_s3_status" {
  description = <<EOF
    CSI S3 deployment status.
  EOF
  value       = try(helm_release.csi_s3[0].status, "n/a")
}

output "external_dns_status" {
  description = <<EOF
    External DNS deployment status.
  EOF
  value       = try(helm_release.external_dns[0].status, "n/a")
}

output "external_secrets_status" {
  description = <<EOF
    External Secrets deployment status.
  EOF
  value       = try(helm_release.external_secrets[0].status, "n/a")
}

output "falco_status" {
  description = <<EOF
    Falco deployment status.
  EOF
  value       = try(helm_release.falco[0].status, "n/a")
}

output "filebeat_oss_status" {
  description = <<EOF
    Filebeat OSS deployment status.
  EOF
  value       = try(helm_release.filebeat_oss[0].status, "n/a")
}

output "filebeat_status" {
  description = <<EOF
    Filebeat deployment status.
  EOF
  value       = try(helm_release.filebeat[0].status, "n/a")
}

output "fluentbit_status" {
  description = <<EOF
    Fluentbit deployment status.
  EOF
  value       = try(helm_release.fluentbit[0].status, "n/a")
}

output "gatekeeper_status" {
  description = <<EOF
    Gatekeeper deployment status.
  EOF
  value       = try(helm_release.gatekeeper[0].status, "n/a")
}

output "gateway_api_status" {
  description = <<EOF
    Gateway API deployment status.
  EOF
  value       = try(helm_release.gateway_api[0].status, "n/a")
}

output "gitlab_agent_status" {
  description = <<EOF
    Gitlab Agent deployment status.
  EOF
  value       = try(helm_release.gitlab_agent[0].status, "n/a")
}

output "gitlab_runner_status" {
  description = <<EOF
    Gitlab Runner deployment status.
  EOF
  value       = try(helm_release.gitlab_runner[0].status, "n/a")
}

output "istio_status" {
  description = <<EOF
    Istio deployment status.
  EOF
  value       = try(helm_release.istio[0].status, "n/a")
}

output "kruise_status" {
  description = <<EOF
    Kruise deployment status.
  EOF
  value       = try(helm_release.kruise[0].status, "n/a")
}

output "kyverno_status" {
  description = <<EOF
    Kyverno deployment status.
  EOF
  value       = try(helm_release.kyverno[0].status, "n/a")
}

output "loki_status" {
  description = <<EOF
    Loki deployment status.
  EOF
  value       = try(helm_release.loki[0].status, "n/a")
}

output "metrics_provider_status" {
  description = <<EOF
    Metrics Provider deployment status.
  EOF
  value       = try(helm_release.metrics_provider[0].status, "n/a")
}

output "ingress_nginx_status" {
  description = <<EOF
    NGINX Ingress deployment status.
  EOF
  value       = try(helm_release.ingress_nginx[0].status, "n/a")
}

output "nodelocal_dns_status" {
  description = <<EOF
    Node-Local DNS deployment status.
  EOF
  value       = try(helm_release.nodelocal_dns[0].status, "n/a")
}

output "policy_reporter_status" {
  description = <<EOF
    Policy Reporter deployment status.
  EOF
  value       = try(helm_release.policy_reporter[0].status, "n/a")
}

output "prometheus_status" {
  description = <<EOF
    Prometheus deployment status.
  EOF
  value       = try(helm_release.prometheus[0].status, "n/a")
}

output "vault_status" {
  description = <<EOF
    Vault deployment status.
  EOF
  value       = try(helm_release.vault[0].status, "n/a")
}

output "velero_status" {
  description = <<EOF
    Velero deployment status.
  EOF
  value       = try(helm_release.velero[0].status, "n/a")
}
