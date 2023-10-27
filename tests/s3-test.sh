stat "awscliv2.zip" || curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
which aws || unzip awscliv2.zip
which aws || sudo ./aws/install
rm -rf aws || true
$(kubectl get secret --namespace tenant-ns myminio-env-configuration -o jsonpath="{.data}" | jq -r ".[\"config.env\"]" | base64 --decode)
echo "MINIO_ROOT_USER=$MINIO_ROOT_USER"
echo "MINIO_ROOT_PASSWORD=$MINIO_ROOT_PASSWORD"
export AWS_ACCESS_KEY_ID=$(echo $MINIO_ROOT_USER | jq -r)
export AWS_SECRET_ACCESS_KEY=$(echo $MINIO_ROOT_PASSWORD | jq -r)
echo "AWS_ACCESS_KEY_ID=$AWS_ACCESS_KEY_ID AWS_SECRET_ACCESS_KEY=$AWS_SECRET_ACCESS_KEY aws --endpoint-url https:// s3 ls"
aws \
    --endpoint-url https:// \
    s3 ls
