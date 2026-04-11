# exit when any command fails
set -e

new_version=$1

echo "new_version: $new_version"

# simulate release of the new docker image 
docker tag nginx:1.23.3 aminlahbib/nginx:$new_version

docker push aminlahbib/nginx:$new_version

# Create a temporary folder where to clone the gitOps repository
temp_dir=$(mktemp -d)
echo "Cloning the gitOps repository into $temp_dir"

target_branch="003/GitOps-CD-for-Kubernetes-with-ArgoCD"

target_root="$temp_dir/003-GitOps-CD-for-Kubernetes-with-ArgoCD"
target_file="$target_root/my-app/1-deployment.yaml"

# Clone the gitOps repository branch that contains the app manifest
git clone --branch "$target_branch" --single-branch https://github.com/aminlahbib/Terraform.git "$temp_dir"

# Update the image tag
if [ ! -f "$target_file" ]; then
  echo "ERROR: expected file not found: $target_file" >&2
  exit 1
fi

sed -i '' "s/aminlahbib\/nginx:.*/aminlahbib\/nginx:$new_version/g" "$target_file"

# Commit and push the changes to the gitOps repository
cd "$temp_dir"
git add .
git commit -m "Update nginx image to version $new_version"
git push

# Clean up the temporary folder
rm -rf $temp_dir