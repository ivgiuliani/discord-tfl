FROM ruby:2.6.5-alpine3.11
MAINTAINER Ivan Giuliani <giuliani.v@gmail.com>

ENV APK_PACKAGES build-base \
                 tzdata curl-dev \
                 ruby ruby-dev ruby-json

RUN set -x && apk update && \
    apk --no-cache add $APK_PACKAGES && \
    rm -rf /var/cache/apk/*

RUN gem install bundler:2.0.2

RUN mkdir /app
WORKDIR /app

COPY Gemfile /app/
COPY Gemfile.lock /app/
RUN bundle install --deployment --jobs 4 --no-cache --without development test

COPY . /app

CMD ["bundle", "exec", "ruby /app/app.rb"]
