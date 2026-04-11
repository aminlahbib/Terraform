# Helm release: installs the Argo CD chart into the cluster.
resource "helm_release" "argocd" {
  # Release name in Helm / cluster.
  name = "argocd"
  # OCI/HTTP repo URL for argo-helm.
  repository = "https://argoproj.github.io/argo-helm"
  # Chart name inside that repository.
  chart = "argo-cd"
  # Target Kubernetes namespace for Argo CD.
  namespace = "argocd"
  # Create the namespace if it does not ^ist.
  create_namespace = true
  # Pin chart version for repeatable installs.
  version = "3.35.4"

  # Merge these values into the chart defaults.
  values = [file("values/argocd.yaml")]

}
