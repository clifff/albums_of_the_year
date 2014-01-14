# Dockerfile - Rails container

FROM ubuntu

RUN apt-get -y install python-software-properties
RUN apt-add-repository -y ppa:brightbox/ruby-ng-experimental
# for supervisord?
RUN echo "deb http://archive.ubuntu.com/ubuntu precise main universe" > /etc/apt/sources.list
RUN apt-get -y update
RUN apt-get -y upgrade
RUN apt-get -y install ruby1.9.3
RUN apt-get -y install build-essential git-core redis-server wget zlib1g-dev libssl-dev libxslt-dev libxml2-dev nodejs
 
# install supervisord
RUN apt-get install -y supervisor
RUN mkdir -p /var/log/supervisor
ADD supervisord.conf /etc/supervisor/conf.d/supervisord.conf

RUN gem install bundler

WORKDIR /tmp 
ADD Gemfile Gemfile
ADD Gemfile.lock Gemfile.lock
RUN bundle install 

# Copy the app into the image.
ADD . /opt/albums_of_the_year
 
WORKDIR /opt/albums_of_the_year

EXPOSE 3000
#CMD ["/bin/bash"]
CMD ["/usr/bin/supervisord"]
