FROM quay.io/evman/environment

COPY --chown=ruby:root Gemfile Gemfile.lock /home/ruby/app/

RUN bundle install --deployment --without=test development
COPY --chown=ruby:root docker/evman.sh Rakefile config.ru \
     package.json yarn.lock .babelrc /home/ruby/app/

COPY --chown=ruby:root bin /home/ruby/app/bin
COPY --chown=ruby:root config /home/ruby/app/config
COPY --chown=ruby:root app /home/ruby/app/app
COPY --chown=ruby:root db /home/ruby/app/db
COPY --chown=ruby:root lib /home/ruby/app/lib
COPY --chown=ruby:root public /home/ruby/app/public

RUN assets.sh
