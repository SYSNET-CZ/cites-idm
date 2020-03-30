FROM ubuntu:18.04

MAINTAINER info@sysnet.cz

ENV APACHEDS_VERSION 2.0.0.AM26
ENV APACHEDS_ARCH amd64
ENV APACHEDS_ARCHIVE apacheds-${APACHEDS_VERSION}-${APACHEDS_ARCH}.deb
ENV APAĆHEDS_PROGRAM_DIR /opt/apacheds-${APACHEDS_VERSION}
ENV APAĆHEDS_INSTANCE_DIR /var/lib/apacheds-${APACHEDS_VERSION}
ENV APACHEDS_DATA /var/lib/apacheds
ENV APACHEDS_USER apacheds
ENV APACHEDS_GROUP apacheds
ENV APACHEDS_INSTANCE production
ENV APACHEDC_SCRIPT apacheds-${APACHEDS_VERSION}-${APACHEDS_INSTANCE}

ARG DEBIAN_FRONTEND=noninteractive

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
    python-ldap

RUN apt-get -qq install -y mc

COPY deb/ .

RUN chmod +x ${APACHEDS_ARCHIVE} && \
    dpkg -i  ${APACHEDS_ARCHIVE} && \
    rm ${APACHEDS_ARCHIVE}


WORKDIR ${APACHEDS_PROGRAM_DIR}

ADD scripts/run.sh /run.sh
RUN chown ${APACHEDS_USER}:${APACHEDS_GROUP} /run.sh \
    && chmod u+rx /run.sh

ADD instance/* ${APACHEDS_BOOTSTRAP}/conf/
ADD ome.ldif ${APACHEDS_BOOTSTRAP}/
RUN mkdir ${APACHEDS_BOOTSTRAP}/cache \
    && mkdir ${APACHEDS_BOOTSTRAP}/run \
    && mkdir ${APACHEDS_BOOTSTRAP}/log \
    && mkdir ${APACHEDS_BOOTSTRAP}/partitions \
    && chown -R ${APACHEDS_USER}:${APACHEDS_GROUP} ${APACHEDS_BOOTSTRAP}












ADD bin /usr/local/bin/









WORKDIR /opt/ds


# Ports defined by the default instance configuration:
# 10389: ldap
# 10636: ldaps
# 60088: kerberos
# 60464: changePasswordServer
# 8080: http
# 8443: https
EXPOSE 10389 10636 60088 60464 8080 8443

CMD /bin/bash

