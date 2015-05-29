############################################################
# Dockerfile to run plone 4.3.5 Containers
# Based on Ubuntu 14.04 Image
############################################################

# base image to use to Ubuntu
FROM ubuntu:14.04

# maintainer
MAINTAINER Maintaner ngi644

# Update the default application repository sources list
RUN apt-get update -y
RUN apt-get upgrade -y

# install modules
RUN sudo apt-get install -y vim ssh build-essential libssl-dev libxml2-dev libxslt1-dev libbz2-dev zlib1g-dev python-setuptools python-dev libjpeg62-dev libreadline-gplv2-dev python-imaging wv poppler-utils mercurial git

# create plone user
RUN adduser --disabled-password plone

# set password for root and plone
RUN bash -c 'echo "root:root" | chpasswd'
RUN bash -c 'echo "plone:plone" | chpasswd'

# setup sshd
RUN apt-get install -y openssh-server
RUN mkdir -p /var/run/sshd && chmod 755 /var/run/sshd

# expose ports
EXPOSE 22 8080 11211

# install plone
USER plone
WORKDIR /home/plone
RUN wget https://launchpad.net/plone/4.3/4.3.5/+download/Plone-4.3.5-UnifiedInstaller.tgz
RUN tar zxvf Plone-4.3.5-UnifiedInstaller.tgz
WORKDIR Plone-4.3.5-UnifiedInstaller
RUN ./install.sh standalone --target=/home/plone/plone4_3_5 --password=admin

#start plone
USER root
CMD su plone -c '/home/plone/plone4_3_5/zinstance/bin/instance start' && /usr/sbin/sshd -D

