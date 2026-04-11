# Terraform block: required providers and versions for this module.
terraform {
  # Declare providers this configuration may use.
  required_providers {
    # Helm provider for installing charts.
    helm = {
      # Terraform registry source for the Helm provider.
      source = "hashicorp/helm"
      # Accept Helm provider 2.13.x (compatible patch/minor range).
      version = "~> 2.13"
    }
  }
}

# Configure the Helm provider to talk to a Kubernetes cluster.
provider "helm" {
  # Credentials and endpoint for Helm’s Kubernetes backend.
  kubernetes {
    # Path to kubeconfig (default cluster context is used).
    config_path = "~/.kube/config"
  }
}
