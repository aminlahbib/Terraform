resource "helm_release" "updater" {
  name = "updater"

  repository       = "https://argoproj.github.io/argo-helm"
  chart            = "argocd-image-updater"
  namespace        = "argocd"
  create_namespace = false
  version          = "1.1.5"

  values = [file("values/image-updater.yaml")]

  # After argocd: namespace + CRDs exist; parallel installs often hang on Helm wait.
  depends_on = [helm_release.argocd]
}