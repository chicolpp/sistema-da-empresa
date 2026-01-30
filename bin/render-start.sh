#!/bin/bash
set -e

echo "Running migrations..."
bundle exec rake db:migrate || bundle exec rake db:setup

echo "Starting Rails server..."
bundle exec rails server -b 0.0.0.0 -p 3000
