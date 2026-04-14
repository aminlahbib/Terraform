resource "helm_release" "updater" {
  name = "updater"

  repository       = "https://argoproj.github.io/argo-helm"
  chart            = "argocd-image-updater"
  namespace        = "argocd"
  create_namespace = true
  version          = "1.1.5"

  values = [file("values/image-updater.yaml")]

  depends_on = [helm_release.argocd]
 }