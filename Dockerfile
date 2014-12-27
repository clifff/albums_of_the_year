FROM ruby
RUN apt-get update -qq && apt-get install -y build-essential libpq-dev
RUN mkdir /aoty
WORKDIR /aoty
ADD Gemfile /aoty/Gemfile
RUN bundle install
RUN if [ '$RAILS_ENV' == 'production' ]; then bundle exec rake assets:precompile ; else exit 0 ; fi
ADD . /aoty
