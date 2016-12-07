FROM registry.gitlab.com/evman/docker-env:latest

ENV RAILS_ENV="production"

USER root

RUN mkdir /app
RUN mkdir /app/log
RUN mkdir /app/tmp

COPY docker/evman/evman.sh /home/evman/evman.sh
RUN chown -R evman:root /home/evman/evman.sh

COPY Gemfile Gemfile.lock Rakefile config.ru /app/
RUN chown -R evman:root /app

USER evman

WORKDIR /app

RUN bundle install --without=test development

COPY bin /app/bin
COPY config /app/config
COPY app /app/app
COPY db /app/db
COPY lib /app/lib
COPY public /app/public

USER root

RUN chown -R evman:root /app

USER evman

RUN bundle exec rake assets:precompile

WORKDIR /home/evman
