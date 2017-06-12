#!/bin/bash

bundle exec puma -e $RAILS_ENV -b tcp://0.0.0.0:3000