# Overview
- This is a tool that allows you to schedule and post on Twitter and Facebook.
# environment setup
## backend
```sh
touch backend/tmp/caching-dev.txt
cp docker/development/nginx/.env.sample docker/development/nginx/.env
cp docker/development/backend/.env.sample docker/development/backend/.env

docker compose build awesome_post_backend
docker compose run --rm awesome_post_backend bundle install
docker compose build awesome_post
docker compose up -d
```
## frontend