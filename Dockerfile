FROM ruby
RUN apt-get update -qq && apt-get install -y build-essential libpq-dev
RUN mkdir /aoty
WORKDIR /aoty
ADD Gemfile /aoty/Gemfile
ADD build.sh /aoty/build.sh
RUN chmod +x /aoty/build.sh
RUN /aoty/build.sh
ADD . /aoty
