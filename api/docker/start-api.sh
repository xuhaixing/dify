#!bin/bash

env=$1
version=$2

docker build -f docker/dify-api.$1.Dockerfile -t xuhaixing/dify-api:$version .

docker stop dify-api dify-worker
docker rm dify-api dify-worker

docker run -d --name dify-api -p 15001:5001 -e MODE=api xuhaixing/dify-api:$version
docker run -d --name dify-worker -e MODE=worker xuhaixing/dify-api:$version