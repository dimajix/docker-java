FROM debian:8.7
MAINTAINER k.kupferschmidt@dimajix.de

ARG JAVA_VERSION_MAJOR=8
ARG JAVA_VERSION_MINOR=131
ARG JAVA_VERSION_BUILD=11
ARG JAVA_PACKAGE=server-jre

USER root

# Upgrade all packages
RUN apt-get update \
    && apt-get -y upgrade \
    && apt-get install -y --no-install-recommends curl tar libtemplate-perl ca-certificates locales \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Users with other locales should set this in their derivative image
ENV LANG=C.UTF-8 \
    LANGUAGE=C.UTF-8 \
    LC_ALL=C.UTF-8 \
    JAVA_HOME=/opt/java
RUN locale-gen C.UTF-8 \
    && update-locale LANG=C.UTF-8

# Install Java
RUN set -ex \
    && curl -sLH "Cookie: oraclelicense=accept-securebackup-cookie" \
      http://download.oracle.com/otn-pub/java/jdk/${JAVA_VERSION_MAJOR}u${JAVA_VERSION_MINOR}-b${JAVA_VERSION_BUILD}/d54c1d3a095b4ff2b6607d096fa80163/${JAVA_PACKAGE}-${JAVA_VERSION_MAJOR}u${JAVA_VERSION_MINOR}-linux-x64.tar.gz \
    | tar xz -C /opt \
    && ln -s /opt/jdk1.${JAVA_VERSION_MAJOR}.0_${JAVA_VERSION_MINOR} ${JAVA_HOME} \
    && ln -s ${JAVA_HOME}/jre/bin ${JAVA_HOME}/bin

# setup environment
ENV PATH=$PATH:$JAVA_HOME/bin:/opt/docker/bin

# copy configs and binaries
COPY libexec/ /opt/docker/libexec/
COPY bin/ /opt/docker/bin/

CMD bash

