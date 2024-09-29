FROM ruby:3.3.5

# fixed env vars
ENV LANG=C.UTF-8
ENV TZ=Asia/Tokyo

# install deps
RUN apt-get update -qq && apt-get install -y default-mysql-client vim
ENV EDITOR=vim

# bundle install
WORKDIR /awesome_post
RUN gem uninstall bundler && gem install bundler -v '2.3.13'
ENV BUNDLE_PATH=/awesome_post/vendor/bundle

# start process for development
# ENTRYPOINT [ "/entrypoint.sh" ]
CMD ["bash"]