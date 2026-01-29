#!/usr/bin/env bash
# Script de build para o Render

set -o errexit

bundle install
bundle exec rake assets:precompile
bundle exec rake assets:clean
bundle exec rake db:migrate
