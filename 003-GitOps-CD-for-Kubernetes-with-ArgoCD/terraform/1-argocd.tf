# Installs Argo CD via Helm: creates the `argocd` namespace, core workloads (controller,
# server, repo-server, Redis, Dex), and CRDs. Values in values/argocd.yaml override chart defaults.

resource "helm_release" "argocd" {
  name       = "argocd"
  repository = "https://argoproj.github.io/argo-helm"
  chart      = "argo-cd"
  namespace = "argocd"
  create_namespace = true
  version = "3.35.4"

  values = [ file("values/argocd.yaml")]
  
}