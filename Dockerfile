FROM alpine:3.8
MAINTAINER Ivan Giuliani <giuliani.v@gmail.com>

ENV APK_PACKAGES build-base \
                 tzdata curl-dev \
                 ruby ruby-bundler ruby-dev ruby-json

RUN apk update && \
    apk upgrade && \
    apk add $APK_PACKAGES && \
    rm -rf /var/cache/apk/*

RUN mkdir /app
WORKDIR /app

COPY Gemfile /app/
COPY Gemfile.lock /app/
RUN bundle install

COPY . /app

CMD ["bundle", "exec", "ruby /app/app.rb"]
