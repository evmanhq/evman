# EvMan

EvMan (Event Manager) is an open-source tool for your team to manage events.
Events are managed from the perspective of people who travel for them (e.g.
developer advocated, etc.) and is not targeted (at this time) to people who
organize events. There is a ton of tools for managing events, however we did
not find any, that would be tweaked for people who attend.

In case you do not want to run your own instance, we are also providing EvMan
as a [service](https://www.evman.io).

EvMan can be run on OpenShift, any other hosting platform or just simple VPS.

## Deploying

How to deploy EvMan.

### Requirements

* Server with Ruby
* PostgreSQL

### Setup environment variables

EvMan configuration values

Variable | Description
--- | ---
EVMAN_HOST | full address to use oauth, e.g. https://www.evman.io
EVMAN_DOMAIN | Main domain part of your service, e.g. evman.io
EVMAN_SCHEME | Scheme used for accessing the service, e.g. https
EVMAN_REQUIRE_INVITATION | If set to 'true' evman will require invitation for new users to register
SECRET_KEY_BASE | Used to encrypt cookie based sessions

Database configuration

Variable | Description
--- | ---
POSTGRES_HOST | Database host
POSTGRES_PORT | Database port
POSTGRES_USER | Database username
POSTGRES_PASSWORD | Database password
POSTGRES_DB | Database name

Oauth configuration

Variable | Description
--- | ---
GITHUB_ID | Oauth key
GITHUB_KEY | Oauth secret
GOOGLE_ID | Oauth key
GOOGLE_KEY | Oauth secret
FACEBOOK_ID | Oauth key
FACEBOOK_KEY | Oauth secret
TWITTER_ID | Oauth key
TWITTER_KEY | Oauth secret
GITLAB_ID | Oauth key
GITLAB_KEY | Oauth secret

AWS configuration, attachments on S3

Variable | Description
--- | ---
S3_BUCKET_NAME | S3 bucket name
AWS_ACCESS_KEY_ID | Amazon id
AWS_SECRET_ACCESS_KEY | Amazon key
AWS_REGION | Region to use for S3

Slack integration

Variable | Description
--- | ---
SLACK_ID | Slack id
SLACK_TOKEN | Slack token
SLACK_CLIENT_ID | Slack client id
SLACK_CLIENT_SECRET | Slack client secret

Mailer

Variable | Description
--- | ---
EMAIL_SENDER | From: header for mailer (Name <name@server.com>)
EMAIL_HOST | SMTP server host
EMAIL_PORT | SMTP server port
EMAIL_USER | SMTP server username
EMAIL_PASS | SMTP server passowrd

Google Analytics

Variable | Description
--- | ---
GOOGLE_ANALYTICS | GA accounts

Mapbox

Variable | Description
--- | ---
MAPBOX_TOKEN | Token for maps from MapBox

### Migrate your database

Create database structure

```
rake db:schema:load
```

or

```
rake db:migrate
```

### Dependencies

To install dependencies run

```
bundle install
```

### Start the application

To start the application, run

```
bundle exec rackup
```

### Import basic geo information

For geo based features, load the prebuild data

```
psql -f geo.sql -d <name> ....
```

### Done

You instance should be up and running.
Navigate to [https://localhost:3000](https://localhost:3000).

### Production

For production use follow the steps above, but also put Nginx in front
of your website. Easiest way is to use
[EvMan's Docker environment](https://github.com/evmanhq/environment).

## Hacking

We welcome all pull requests, bug reports and request for enhancements.

You agree that your contributions are provided under the same
license as the project itself.

## GeoNames

The geo information is based on the awesome work of
[GeoNames](http://www.geonames.org).

## Theme

The theme is based on the awesome work of [CoreUI](http://coreui.io).

## Copyright

Copyright © 2015-2018 Red Hat employees (Marek Jelen, Filip Zachar)

See LICENSE.txt for further details.
