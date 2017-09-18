FROM docker.io/evman/docker-env:latest

USER root
RUN curl -sL https://rpm.nodesource.com/setup_7.x | bash - &&\
    curl https://dl.yarnpkg.com/rpm/yarn.repo -o /etc/yum.repos.d/yarn.repo &&\
    yum install -y nodejs yarn

USER evman

ENV RAILS_ENV="production"

USER root

RUN mkdir /app
RUN mkdir /app/log
RUN mkdir /app/tmp

COPY docker/evman.sh /home/evman/evman.sh
RUN chown -R evman:root /home/evman/evman.sh

COPY Gemfile \
     Gemfile.lock \
     Rakefile \
     config.ru \
     /app/
RUN chown -R evman:root /app

USER evman

WORKDIR /app

RUN bundle install --without=test development

COPY package.json \
     yarn.lock \
     .babelrc \
     /app/

COPY bin /app/bin
COPY config /app/config
COPY app /app/app
COPY db /app/db
COPY lib /app/lib
COPY public /app/public

USER root

# Remove packs from development
RUN rm -rf /app/public/packs

RUN chown -R evman:root /app

USER evman

ENV NODE_ENV="production"

RUN bundle exec rake assets:precompile

WORKDIR /home/evman
