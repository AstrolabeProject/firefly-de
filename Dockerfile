FROM azul/zulu-openjdk:8

MAINTAINER Tom Hicks <hickst@email.arizona.edu>

ENV CATALINA_HOME /usr/local/tomcat
ENV PATH $CATALINA_HOME/bin:$PATH

RUN mkdir -p "$CATALINA_HOME"
WORKDIR $CATALINA_HOME

RUN apt-get update \
    && apt-get install -y wget gnupg curl \
    && apt-get clean \
    && rm -rf /usr/lib/apt/lists/*

# see https://www.apache.org/dist/tomcat/tomcat-8/KEYS
# RUN gpg --keyserver pgpkeys.mit.edu --recv-keys \
# 0D811BBE \
# 731FABEE \
# 0D498E23 \
# D63011C7

ENV TOMCAT_MAJOR 8
ENV TOMCAT_VERSION 8.0.53
ENV TOMCAT_TGZ_URL https://www.apache.org/dist/tomcat/tomcat-$TOMCAT_MAJOR/v$TOMCAT_VERSION/bin/apache-tomcat-$TOMCAT_VERSION.tar.gz

RUN set -x \
    && curl -fSL "$TOMCAT_TGZ_URL" -o tomcat.tar.gz \
    && curl -fSL "$TOMCAT_TGZ_URL.asc" -o tomcat.tar.gz.asc \
    # && gpg --verify tomcat.tar.gz.asc tomcat.tar.gz \
    && tar -xvf tomcat.tar.gz --strip-components=1 \
    && rm bin/*.bat \
    && rm tomcat.tar.gz* \
    && rm -rf /usr/local/tomcat/webapps/docs /usr/local/tomcat/webapps/examples

RUN mkdir /data

COPY ./firefly.war $CATALINA_HOME/webapps/firefly.war
COPY ./tomcat-users.xml /usr/local/tomcat/conf/
ENV CATALINA_OPTS -server -Xms512m -Xmx2048m -XX:MaxPermSize=256m

EXPOSE 8080
CMD ["catalina.sh", "run"]
