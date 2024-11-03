#!/bin/bash

set -e

# mysql health check
echo 'Waiting for mysql ...'
count=1
result=0
while [ $result -eq 0 ]; do
  echo "********** Health check for mysql: $count th try **********"

  if [ $count -gt 90 ]; then
    echo 'XXXXXXXXXX mysql is unhealthy.'
    exit 1
  fi

  resp=$(mysql --host=$DB_HOST --port=$DB_PORT --user=$DB_USER --password=$DB_PASSWORD --execute="SHOW DATABASES;" | awk '/Database/ { print $1 }')
  if [ $resp = 'Database' ]; then
    result=1
    break
  fi

  sleep 1
  count=$((++count))
done
echo 'mysql is healthy.'

if [ -f /awesome_post/tmp/pids/server.pid ]; then
    rm /awesome_post/tmp/pids/server.pid
fi

exec "$@"
