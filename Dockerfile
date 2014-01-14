# Dockerfile - Rails container

FROM ubuntu

RUN echo "deb http://archive.ubuntu.com/ubuntu precise main universe" > /etc/apt/sources.list
RUN apt-get -y update
RUN apt-get -y upgrade
RUN apt-get -y install build-essential git-core redis-server wget zlib1g-dev libssl-dev libxslt-dev libxml2-dev

# install supervisord
RUN apt-get install -y supervisor
RUN mkdir -p /var/run/sshd
RUN mkdir -p /var/log/supervisor
ADD supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# install rbenv
RUN git clone https://github.com/sstephenson/rbenv /usr/local/rbenv
RUN mkdir -p /usr/local/rbenv/plugins
RUN git clone https://github.com/sstephenson/ruby-build.git /usr/local/rbenv/plugins/ruby-build

ENV RBENV_ROOT /usr/local/rbenv
ENV PATH /usr/local/rbenv/shims:/usr/local/rbenv/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin

RUN rbenv install 1.9.3-p429
ENV RBENV_VERSION 1.9.3-p429

RUN rbenv rehash
RUN gem install bundler
RUN rbenv rehash

# Copy the app into the image.
ADD . /opt/albums_of_the_year
 
# Now that the app is here, we can bundle.
WORKDIR /opt/albums_of_the_year
RUN bundle install

EXPOSE 3000
CMD ["/usr/bin/supervisord"]
