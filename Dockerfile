FROM ubuntu:18.04

ARG CHANNEL=stable
ARG CHEF_VERSION=3.8.14

ENV DEBIAN_FRONTEND=noninteractive \
  PATH=/opt/chefdk/bin:/opt/chefdk/embedded/bin:/root/.chefdk/gem/ruby/2.5.0/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin


RUN apt-get update && \
  apt-get install -y apt-transport-https \
  ca-certificates \
  curl \
  software-properties-common \
  wget \
  openssh-client \
  make
# install docker
RUN curl -fsSL "https://download.docker.com/linux/$(lsb_release -is | awk '{print tolower($0)}')/gpg" | apt-key add - && \
  add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/$(lsb_release -is | awk '{print tolower($0)}') $(lsb_release -cs) stable" && \
  apt-get update && \
  apt-get install -y docker-ce

RUN apt-get install -y build-essential virtualbox vagrant
# https://packages.chef.io/files/stable/chefdk/3.6.57/ubuntu/16.04/chefdk_3.6.57-1_amd64.deb
RUN wget --quiet --content-disposition "http://packages.chef.io/files/${CHANNEL}/chefdk/${CHEF_VERSION}/$(lsb_release -is | awk '{print tolower($0)}')/$(lsb_release -rs )/chefdk_${CHEF_VERSION}-1_amd64.deb" -O /tmp/chefdk.deb && \
  dpkg -i /tmp/chefdk.deb && \
  chef gem install kitchen-docker && \
  chef gem install kitchen-openstack && \
  chef gem install knife-openstack && \
  apt-get remove -y build-essential && \
  apt-get autoremove -y && \
  apt-get clean && \
  rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

VOLUME /var/run/docker.sock
