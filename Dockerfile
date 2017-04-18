FROM ubuntu:16.04
MAINTAINER k.kupferschmidt@dimajix.de

ARG BUILD_JAVA_VERSION=8

USER root

# Users with other locales should set this in their derivative image
ENV LANG=en_US.UTF-8 \
    LANGUAGE=en_US:en \
    LC_ALL=en_US.UTF-8
RUN locale-gen en_US.UTF-8 \
    && update-locale LANG=en_US.UTF-8

# Upgrade all packages
RUN apt-get update \
    && apt-get -y upgrade \
    && apt-get install -y --no-install-recommends curl tar zlib1g-dev zlib1g libtemplate-perl ca-certificates

# Install Java
RUN echo "deb http://ppa.launchpad.net/webupd8team/java/ubuntu xenial main" | tee /etc/apt/sources.list.d/webupd8team-java.list \
    && echo "deb-src http://ppa.launchpad.net/webupd8team/java/ubuntu xenial main" | tee -a /etc/apt/sources.list.d/webupd8team-java.list \
    && apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys EEA14886 \
    && apt-get update
RUN echo oracle-java${BUILD_JAVA_VERSION}-installer shared/accepted-oracle-license-v1-1 select true | /usr/bin/debconf-set-selections \ 
    && apt-get install -y --no-install-recommends oracle-java${BUILD_JAVA_VERSION}-installer oracle-java${BUILD_JAVA_VERSION}-set-default \
    && apt-get clean

# Set Java environment
ENV JAVA_HOME=/usr/lib/jvm/java-${BUILD_JAVA_VERSION}-oracle

# setup environment
ENV PATH=$PATH:$JAVA_HOME/bin:/opt/docker/bin

# copy configs and binaries
COPY libexec/ /opt/docker/libexec/
COPY bin/ /opt/docker/bin/

CMD bash

