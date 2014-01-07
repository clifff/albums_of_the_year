# Dockerfile - Rails container

FROM ubuntu

RUN apt-get -y update
RUN apt-get -y install build-essential git-core wget zlib1g-dev

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

CMD /bin/echo hello world
