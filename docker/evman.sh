#!/usr/bin/env bash

cd /app

bundle exec rake db:migrate
bundle exec puma -e $RAILS_ENV -b tcp://127.0.0.1:3000 --state=/home/evman/evman.state