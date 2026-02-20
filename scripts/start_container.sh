 #!/bin/bash
set -e
export IMAGE_URI=$(cat /opt/codedeploy/image_uri.txt)
RELEASE_NAME="${RELEASE_NAME:-$(date +%Y%m%d-%H%M%S)}"
CONTAINER_NAME="cmtr-ac8bmr88-north-pole"
docker run -d \
    --name $CONTAINER_NAME \
    --restart unless-stopped \
    -p 8080:8080 \
    -e RELEASE_NAME="$RELEASE_NAME" \
    $IMAGE_URI