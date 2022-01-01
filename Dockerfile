FROM ruby:3.1.0-alpine
MAINTAINER Ivan Giuliani <giuliani.v@gmail.com>

ENV APK_PACKAGES build-base \
                 tzdata curl-dev git \
                 ruby ruby-dev ruby-json

RUN set -x && apk update && \
    apk --no-cache add $APK_PACKAGES && \
    rm -rf /var/cache/apk/*

RUN mkdir /app
WORKDIR /app

COPY Gemfile /app/
COPY Gemfile.lock /app/

RUN set -x \
      && gem install bundler -v 2.3.3 --no-document \
      && bundle config --global set without 'development test' \
      && bundle config --global set deployment 'true' \
      && bundle config --global set clean 'true' \
      && bundle config --global set no-cache 'true' \
      && bundle install \
      --jobs=4 \
      --retry=3

COPY . /app

CMD ["bundle", "exec", "ruby /app/app.rb"]
