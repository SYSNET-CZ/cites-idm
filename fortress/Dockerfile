FROM ubuntu:18.04

MAINTAINER info@sysnet.cz

ARG DEBIAN_FRONTEND=noninteractive
ARG HOME_DIR=/opt/fortress

RUN apt-get update && apt-get -y install locales
RUN sed -i -e 's/# cs_CZ.UTF-8 UTF-8/cs_CZ.UTF-8 UTF-8/' /etc/locale.gen && \
    dpkg-reconfigure --frontend=noninteractive locales && \
    update-locale LANG=cs_CZ.UTF-8

ENV LANG cs_CZ.UTF-8

RUN apt-get -qq install -y \
    apt-utils \
    ldap-utils \
    curl \
    wget \
    procps \
    default-jdk \
    maven \
    git

RUN apt-get -qq install -y mc

ENV FORTRESS_HOME=${HOME_DIR}

WORKDIR ${HOME_DIR}

RUN git clone  https://gitbox.apache.org/repos/asf/directory-fortress-core.git
RUN cd directory-fortress-core
COPY build.properties .
RUN mvn clean install
RUN mvn install -Dload.file=./ldap/setup/refreshLDAPData.xml
RUN mvn install -Dload.file=./ldap/setup/DelegatedAdminManagerLoad.xml



# ------------------------------------------------------------------------

CMD /bin/bash
