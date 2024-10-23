FROM nginx:stable-alpine

# fixed env vars
ENV LANG=C.UTF-8
ENV TZ=Asia/Tokyo

# install deps
RUN apk add bash vim
ENV EDITOR=vim

# start process for development
WORKDIR /awesome_post
ENTRYPOINT [ "/awesome_post/entrypoint.sh" ]
CMD ["ash"]