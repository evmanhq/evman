#!/usr/bin/env bash

bundle exec rake db:migrate
bundle exec puma -w 3 -t 5:5 -e $RAILS_ENV -b tcp://127.0.0.1:3000 --state=/home/evman/evman.state
