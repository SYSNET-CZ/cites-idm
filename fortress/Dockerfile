FROM ubuntu:18.04

MAINTAINER info@sysnet.cz

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
    default-jdk \
    maven \
    git

RUN apt-get -qq install -y mc

WORKDIR /opt/fortress

RUN git clone  https://gitbox.apache.org/repos/asf/directory-fortress-core.git
RUN cd directory-fortress-core
COPY build.properties .
RUN mvn clean install
RUN mvn install -Dload.file=./ldap/setup/refreshLDAPData.xml
RUN mvn install -Dload.file=./ldap/setup/DelegatedAdminManagerLoad.xml



# ------------------------------------------------------------------------

COPY deb .
RUN chmod +x ${APACHEDS_ARCHIVE} && \
    dpkg -i  ${APACHEDS_ARCHIVE} && \
    rm ${APACHEDS_ARCHIVE}

ADD scripts  /etc/init.d/${APACHEDS_SCRIPT}
RUN chmod u+rx /etc/init.d/${APACHEDS_SCRIPT}
RUN ln -s /etc/init.d/${APACHEDS_SCRIPT} /etc/init.d/apacheds

ADD instance ${APACHEDS_INSTANCE_DIR}/conf/
RUN mkdir ${APACHEDS_INSTANCE_DIR}/cache \
    && mkdir ${APACHEDS_INSTANCE_DIR}/run \
    && mkdir ${APACHEDS_INSTANCE_DIR}/log \
    && mkdir ${APACHEDS_INSTANCE_DIR}/partitions \
    && chown -R ${APACHEDS_USER}:${APACHEDS_GROUP} ${APACHEDS_INSTANCE_DIR}



# Ports defined by the default instance configuration:
# 10389: ldap
# 10636: ldaps
# 60088: kerberos
# 60464: changePasswordServer
# 8080: http
# 8443: https
EXPOSE 10389 10636 60088 60464 8080 8443

CMD /etc/init.d/apacheds start
