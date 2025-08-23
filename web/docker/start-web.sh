#!bin/bash

# 启动指令示例：
# sh docker/start-web.sh 160 1.4.1

env=$1
version=$2
MIGRATION_ENABLED=$3

if [ -z "$env" ] || [ -z "$version" ]; then
  echo "Usage: $0 <env> <version>"
  exit 1
fi


docker stop dify-web
docker rm dify-web
docker rmi $(docker images | grep "dify-web"  | awk '{print $3}')

dockerfile_path="docker/dify-web.Dockerfile"


docker build -f $dockerfile_path  --build-arg APP_ENV=$env -t xuhaixing/dify-web:$version .

echo "Starting new dify-web container..."
docker run -d --name dify-web -p 13000:3000 xuhaixing/dify-web:$version


echo "Done. Containers are up and running."