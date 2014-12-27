FROM ruby
RUN apt-get update -qq && apt-get install -y build-essential libpq-dev
RUN mkdir /aoty
WORKDIR /aoty
ADD Gemfile /aoty/Gemfile
RUN bundle install
ADD . /aoty
