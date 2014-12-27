#!/bin/bash
cd /aoty
bundle install
if [ '$RAILS_ENV' == 'production' ]; then
  bundle exec rake assets:precompile
else
  exit 0
fi
