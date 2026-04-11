# Terraform

Hands on practice for Terraform and IaC

- **`001/`** — starter infra + static site  
- **`002-terraform-gcp/terraform/`** — GCP VPC, NAT, firewall  
- **`003-GitOps-ArgoCD/`** — Argo CD (Terraform), example apps + staging manifests  

Use `terraform init` / `plan` / `apply` inside each project's Terraform folder. Keep secrets out of git (`terraform.tfvars` is ignored).


## Debugging: `helm_release.updater` stuck and failing

**Root cause:** Two issues in `values/image-updater.yaml`:

1. **Chart/image version mismatch (primary crash).** Chart `1.1.5` (appVersion `v1.1.1`) injects the CLI flag `--metrics-bind-address=:8443` into the pod args. Your pinned image `v0.12.2` is a v0.x binary that doesn't recognize that flag, so it immediately exits with code 1, entering CrashLoopBackOff. Helm's default `wait=true` then blocks for 5 minutes until context deadline exceeded.

2. **Nested `config.argocd` rendered as Go map literal.** Chart 1.1.5 expects flat dotted keys (`argocd.serverAddress`, `argocd.insecure`, etc.) under `config`. Passing a nested YAML object (`config.argocd.serverAddress`) caused the chart to stringify it as `map[grpcWeb:true insecure:true ...]` — garbage to the image-updater.

**Fix applied:** Removed `image.tag: "v0.12.2"` (now uses chart default `v1.1.1`), and flattened the `config.argocd` keys to dotted notation.
