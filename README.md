# Overview
- This is a tool that allows you to schedule and post on Twitter and Facebook.
# environment setup
## backend
```sh
docker compose build awesome_post_backend
docker compose run --rm awesome_post_backend bundle install
docker compose up -d
```
## frontend