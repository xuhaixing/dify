#!bin/bash

# 启动指令示例：
# sh docker/start-api.sh 160 1.4.1

env=$1
version=$2
MIGRATION_ENABLED=$3

if [ -z "$env" ] || [ -z "$version" ]; then
  echo "Usage: $0 <env> <version>"
  exit 1
fi

if [ -z "$MIGRATION_ENABLED" ]; then
    MIGRATION_ENABLED="false"
fi

dockerfile_path="docker/dify-api.${env}.Dockerfile"


docker build -f $dockerfile_path -t xuhaixing/dify-api:$version .

docker stop dify-api dify-worker
docker rm dify-api dify-worker
docker rmi xuhaixing/dify-api:$version

echo "Starting new dify-api container..."
docker run -d --name dify-api -p 15001:5001 -e MODE=api -e MIGRATION_ENABLED=$MIGRATION_ENABLED xuhaixing/dify-api:$version

echo "Starting new dify-worker container..."
docker run -d --name dify-worker -e MODE=worker -e MIGRATION_ENABLED=$MIGRATION_ENABLED xuhaixing/dify-api:$version

echo "Done. Containers are up and running."