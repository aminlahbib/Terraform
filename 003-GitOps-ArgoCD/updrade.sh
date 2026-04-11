#!/usr/bin/env bash
# CI/GitOps demo: push a new nginx image tag and bump the Deployment image in Git on a branch.
# Abort the script if any command fails.
set -e

# New image tag from first script argument.
new_version=$1

# Print the version being promoted.
echo "new_version: $new_version"

# Tag local base image as your registry image with the new tag.
docker tag nginx:1.23.3 aminlahbib/nginx:$new_version

# Push the new tag to the registry.
docker push aminlahbib/nginx:$new_version

# Create a temp directory for a disposable clone.
temp_dir=$(mktemp -d)
echo "Cloning the gitOps repository into $temp_dir"

# Branch that holds the GitOps manifests this script updates.
target_branch="003/GitOps-CD-for-Kubernetes-with-ArgoCD"

# Expected root path inside the clone (must match repo layout).
target_root="$temp_dir/003-GitOps-CD-for-Kubernetes-with-ArgoCD"
# Deployment file to patch (note: path may differ from current repo layout).
target_file="$target_root/my-app/1-deployment.yaml"

# Shallow clone of a single branch.
git clone --branch "$target_branch" --single-branch https://github.com/aminlahbib/Terraform.git "$temp_dir"

# Fail fast if the expected manifest path is missing.
if [ ! -f "$target_file" ]; then
  echo "ERROR: expected file not found: $target_file" >&2
  exit 1
fi

# Replace image reference with the new tag (macOS sed in-place).
sed -i '' "s/aminlahbib\/nginx:.*/aminlahbib\/nginx:$new_version/g" "$target_file"

# Commit and push from the clone so Argo CD can sync the new tag.
cd "$temp_dir"
git add .
git commit -m "Update nginx image to version $new_version"
git push

# Remove the temporary clone.
rm -rf $temp_dir
