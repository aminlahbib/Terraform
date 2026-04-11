# Terraform Helm provider: used to install Argo CD from the official argo-helm chart.
# kubeconfig at ~/.kube/config must point at the cluster where you want Argo CD to run.

terraform {
  required_providers {
    helm = {
      source  = "hashicorp/helm"
      version = "~> 2.13"
    }
  }
}

provider "helm" {
  kubernetes {
    config_path = "~/.kube/config"
  }
}