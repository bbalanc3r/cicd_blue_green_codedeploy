#!/bin/bash
set -e

export IMAGE_URI=$(cat /opt/codedeploy/image_uri.txt)

# Derive ECR region from image URI (format: account.dkr.ecr.region.amazonaws.com/repo)
ECR_REGION=$(echo $IMAGE_URI | cut -d. -f4)

# Login to ECR and pull the new image
aws ecr get-login-password --region $ECR_REGION | docker login --username AWS --password-stdin $(echo $IMAGE_URI | cut -d/ -f1)

# Pull the new image
docker pull $IMAGE_URI