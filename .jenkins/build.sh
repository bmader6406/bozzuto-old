#!/bin/bash
set -e

cd $(dirname "$0")/..

# Set Ruby version
source /etc/profile.d/rbenv.sh
rbenv shell `head -1 .ruby-version`

# Start services
/etc/service/mysql/run &

# Set up config files
cp config/database.yml{.example,}
cp config/app_config.yml{.example,}

# Run tests
export RAILS_ENV=test
bundle install
bundle exec rake db:create
bundle exec rake db:migrate:reset
bundle exec rake test:coverage
