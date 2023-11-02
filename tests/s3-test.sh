stat "awscliv2.zip" || curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
which aws || unzip awscliv2.zip
which aws || sudo ./aws/install
rm -rf aws || true
echo
set -e -o pipefail
source .env
ENDPOINT="http-tenant-picloud-hl-tenant-ns-9000.$DOMAIN"
PIC_DIR="$HOME/.pic"
cat "$PIC_DIR/s3.json"
ACCESS_KEY_ID=$(jq -r '.ACCESS_KEY_ID' $PIC_DIR/s3.json)
SECRET_ACCESS_KEY=$(jq -r '.SECRET_ACCESS_KEY' $PIC_DIR/s3.json)

export AWS_ACCESS_KEY_ID=$ACCESS_KEY_ID
export AWS_SECRET_ACCESS_KEY=$SECRET_ACCESS_KEY
echo "AWS_ACCESS_KEY_ID=$AWS_ACCESS_KEY_ID AWS_SECRET_ACCESS_KEY=$AWS_SECRET_ACCESS_KEY aws --endpoint-url https://$ENDPOINT s3 ls"

AWS_ACCESS_KEY_ID=$AWS_ACCESS_KEY_ID AWS_SECRET_ACCESS_KEY=$AWS_SECRET_ACCESS_KEY aws --endpoint-url https://$ENDPOINT s3 ls
