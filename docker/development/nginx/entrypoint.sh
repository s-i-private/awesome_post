#!/bin/bash

set -e

cd /awesome_post

# dockerホストのIPアドレス取得
export DOCKER_HOST=$(ip route | awk '/default/ { print $3 }')
echo "DOCKER_HOST is $DOCKER_HOST"

# $AWESOME_POST_BACKEND_HOST のチェック
if [ ! $AWESOME_POST_BACKEND_HOST ]; then
  echo "use DOCKER_HOST as AWESOME_POST_BACKEND_HOST"
  export AWESOME_POST_BACKEND_HOST=$(echo $DOCKER_HOST)
fi
echo "AWESOME_POST_BACKEND_HOST is $AWESOME_POST_BACKEND_HOST"

# $AWESOME_POST_BACKEND_PORT のチェック
if [ ! $AWESOME_POST_BACKEND_PORT ]; then
  echo 'use default AWESOME_POST_BACKEND_PORT 33000'
  export AWESOME_POST_BACKEND_PORT=33000
fi
echo "AWESOME_POST_BACKEND_PORT is $AWESOME_POST_BACKEND_PORT"

# $AWESOME_POST_FRONTEND_HOST のチェック
if [ ! $AWESOME_POST_FRONTEND_HOST ]; then
  echo "use DOCKER_HOST as AWESOME_POST_FRONTEND_HOST"
  export AWESOME_POST_FRONTEND_HOST=$(echo $DOCKER_HOST)
fi
echo "AWESOME_POST_FRONTEND_HOST is $AWESOME_POST_FRONTEND_HOST"

# $AWESOME_POST_FRONTEND_PORT のチェック
if [ ! $AWESOME_POST_FRONTEND_PORT ]; then
  echo 'use default AWESOME_POST_FRONTEND_PORT 43000'
  export AWESOME_POST_FRONTEND_PORT=43000
fi
echo "AWESOME_POST_FRONTEND_PORT is $AWESOME_POST_FRONTEND_PORT"

# nginx用設定ファイルの作成
if [ $FRONT_STATIC_DEPLOY_TEST = 'true' ]; then
  envsubst '$$AWESOME_POST_BACKEND_HOST $$AWESOME_POST_BACKEND_PORT $$AWESOME_POST_FRONTEND_HOST $$AWESOME_POST_FRONTEND_PORT' < front_static_deploy_test.conf > /etc/nginx/conf.d/default.conf
else
  envsubst '$$AWESOME_POST_BACKEND_HOST $$AWESOME_POST_BACKEND_PORT $$AWESOME_POST_FRONTEND_HOST $$AWESOME_POST_FRONTEND_PORT' < default.conf > /etc/nginx/conf.d/default.conf
fi

# awesome_post_backend health check
echo 'Waiting for awesome_post_backend ...'
count=1
result=0
while [ $result -eq 0 ]; do
  if [ $count -gt 150 ]; then
    echo 'XXXXXXXXXX awesome_post_backend is unhealthy.'
    exit 1
  fi

  echo "********** Health check for awesome_post_backend: $count th try **********"

  status=$(curl -if http://$AWESOME_POST_BACKEND_HOST:$AWESOME_POST_BACKEND_PORT | awk 'NR==1{ print $2}')
  if [ "$status" = '204' ]; then
    result=1
    break;
  fi

  sleep 1

  count=$((++count))
done

echo "AWESOME_POST_backend $AWESOME_POST_BACKEND_HOST:$AWESOME_POST_BACKEND_PORT is healthy."

exec "$@"
