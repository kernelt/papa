#!/bin/bash
set -e

read -p "AWS_ECR_URI: " ecr_addr

docker build -t papa-webapp .
docker tag papa-webapp:latest $ecr_addr:latest
docker push $ecr_addr:latest