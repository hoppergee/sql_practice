FROM ruby:2.6.6-alpine3.12

RUN apk add --no-cache mysql-client make gcc libc-dev mariadb-dev build-base

RUN gem install bundler:2.0.2

RUN mkdir /app
COPY ./Gemfile /app/Gemfile
COPY ./Gemfile.lock /app/Gemfile.lock

RUN cd /app && bundle install

WORKDIR /app