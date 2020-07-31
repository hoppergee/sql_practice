FROM ruby:2.6.6-alpine3.12

RUN apk add --no-cache mysql

RUN gem install minitest

WORKDIR /app