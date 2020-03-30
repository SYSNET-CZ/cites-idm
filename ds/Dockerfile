FROM ubuntu:18.04

MAINTAINER info@sysnet.cz

# Parametry pro sestavení obrazu
ARG VERSION=2.0.0.AM26
ARG ARCH=amd64
ARG ARCHIVE=apacheds-${VERSION}-${ARCH}.deb
ARG PROGRAM_DIR=/opt/apacheds-${VERSION}
ARG DATA_DIR=/var/lib/apacheds-${VERSION}
ARG USER=apacheds
ARG GROUP=apacheds
ARG INSTANCE=production
ARG INSTANCE_DIR=${DATA_DIR}/${INSTANCE}
ARG SCRIPT=apacheds-${VERSION}-${INSTANCE}
ARG DEBIAN_FRONTEND=noninteractive
ARG BOOTSTRAP=${DATA_DIR}/bootstrap

# Systémové proměnné obrazu
ENV APACHEDS_VERSION=${VERSION} \
    APACHEDS_ARCHIVE=${ARCHIVE} \
    APACHEDS_PROGRAM_DIR=${PROGRAM_DIR} \
    APACHEDS_DATA_DIR=${DATA_DIR} \
    APACHEDS_USER=${USER} \
    APACHEDS_GROUP=${GROUP} \
    APACHEDS_INSTANCE=${INSTANCE} \
    APACHEDS_INSTANCE_DIR=${INSTANCE_DIR} \
    APACHEDS_SCRIPT=${SCRIPT} \
    APACHEDS_BOOTSTRAP=${BOOTSTRAP}

WORKDIR ${PROGRAM_DIR}

# Instalace českého nastavení
RUN apt-get update && apt-get -qq install -y locales
RUN sed -i -e 's/# cs_CZ.UTF-8 UTF-8/cs_CZ.UTF-8 UTF-8/' /etc/locale.gen && \
    dpkg-reconfigure --frontend=noninteractive locales && \
    update-locale LANG=cs_CZ.UTF-8

ENV LANG=cs_CZ.UTF-8 \
    LC_ALL=cs_CZ.UTF-8 \
    LANGUAGE=cs_CZ.UTF-8

# Instalace potřebných balíků
RUN apt-get -qq install -y \
    apt-utils \
    ldap-utils \
    curl \
    wget \
    procps \
    python-ldap
RUN apt-get -qq install -y default-jdk

RUN apt-get -qq install -y mc

# Instalace vlastního Apache DS
# http://mirror.hosting90.cz/apache/directory/apacheds/dist/2.0.0.AM26/apacheds-2.0.0.AM26-amd64.deb
# COPY deb/${ARCHIVE} .
RUN wget -nv --show-progress --progress=bar:force:noscroll http://mirror.hosting90.cz/apache/directory/apacheds/dist/${VERSION}/${ARCHIVE}
RUN chmod +x ${ARCHIVE} && \
    dpkg -i  ${ARCHIVE} && \
    rm ${ARCHIVE}

# Ovládací skripty
ADD bin /usr/local/bin

# Spouštěcí skripty - služba nefunguje
ADD scripts/${SCRIPT}  /etc/init.d/${SCRIPT}
RUN chmod u+rx /etc/init.d/${SCRIPT}
RUN ln -s /etc/init.d/${SCRIPT} /etc/init.d/apacheds

# Spouštěcí skripty dumb init
RUN wget -nv --show-progress --progress=bar:force:noscroll -O /usr/local/bin/dumb-init https://github.com/Yelp/dumb-init/releases/download/v1.2.2/dumb-init_1.2.2_amd64
RUN chmod +x /usr/local/bin/dumb-init
ADD scripts/run.sh run.sh
RUN chown ${USER}:${GROUP} run.sh && chmod u+rx run.sh
RUN ln -s ${PROGRAM_DIR}/run.sh /run.sh

# Vytvoření šablony instance
ADD instance/* ${BOOTSTRAP}/conf/
ADD sysnet.ldif ${BOOTSTRAP}/
RUN mkdir ${BOOTSTRAP}/cache \
    && mkdir ${BOOTSTRAP}/run \
    && mkdir ${BOOTSTRAP}/log \
    && mkdir ${BOOTSTRAP}/partitions \
    && chown -R ${USER}:${GROUP} ${BOOTSTRAP}

# Nastavení produkční instance
ADD instance ${INSTANCE_DIR}/conf/
ADD sysnet.ldif ${INSTANCE_DIR}
RUN mkdir ${INSTANCE_DIR}/cache \
    && mkdir ${INSTANCE_DIR}/run \
    && mkdir ${INSTANCE_DIR}/log \
    && mkdir ${INSTANCE_DIR}/partitions \
    && chown -R ${USER}:${GROUP} ${INSTANCE_DIR}

# Ports defined by the default instance configuration:
# 10389: ldap
# 10636: ldaps
# 60088: kerberos
# 60464: changePasswordServer
# 8080: http
# 8443: https
EXPOSE 10389 10636 60088 60464 8080 8443

# Correct for hard-coded INSTANCES_DIRECTORY variable
# RUN sed -i "s#/var/lib/apacheds-${VERSION}#/var/lib/apacheds#" /opt/apacheds-${VERSION}/bin/apacheds

# Instalace dumb-init
RUN curl -L -o /usr/local/bin/dumb-init \
    https://github.com/Yelp/dumb-init/releases/download/v1.2.1/dumb-init_1.2.1_amd64 && \
    chmod +x /usr/local/bin/dumb-init

ENTRYPOINT ["/run.sh"]
# CMD /bin/bash
