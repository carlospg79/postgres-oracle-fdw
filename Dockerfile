FROM postgres:9.4.4

ENV HOME=/root DEBIAN_FRONTEND=noninteractive DEBCONF_NONINTERACTIVE_SEEN=true

RUN true \
 && apt-get update -yy \
 && apt-get upgrade -yy \
 && apt-get install -yy --no-install-recommends \
             wget unzip ca-certificates libaio1 \
 && localedef -i en_US -c -f UTF-8 -A /usr/share/locale/locale.alias en_US.UTF-8 \
 && apt-get clean -yy \
 && apt-get autoclean -yy \
 && apt-get autoremove -yy \
 && rm -rf /var/cache/debconf/*-old \
 && rm -rf /var/lib/apt/lists/* \
 && true


ENV ORACLE_HOME=/usr/local/instantclient LD_LIBRARY_PATH=/usr/local/instantclient
RUN INSTANT_CLIENT_VERSION=11.2.0.4.0 \
 && cd /tmp \
 && NAME=basic && wget "https://github.com/FabriZZio/docker-php-oci8/blob/master/oracle/instantclient-$NAME-linux.x64-$INSTANT_CLIENT_VERSION.zip?raw=true" -O $NAME.zip \
 && NAME=sqlplus && wget "https://github.com/FabriZZio/docker-php-oci8/blob/master/oracle/instantclient-$NAME-linux.x64-$INSTANT_CLIENT_VERSION.zip?raw=true" -O $NAME.zip \
 && unzip /tmp/basic.zip -d /usr/local \
 && unzip /tmp/sqlplus.zip -d /usr/local \
 && rm -rf /tmp/* \
 && true

RUN true \
 && ln -s /usr/local/instantclient_* /usr/local/instantclient \
 && ln -s /usr/local/instantclient/libclntsh.so.* /usr/local/instantclient/libclntsh.so \
 && ln -s /usr/local/instantclient/sqlplus /usr/bin/sqlplus \
 && true

ADD ./target /opt

RUN true \
 && apt-get update -y \
 && for i in /opt/*.deb ; do dpkg -i $i ; done \
 && apt-get install -f \
 && apt-get clean -yy \
 && apt-get autoclean -yy \
 && apt-get autoremove -yy \
 && rm -rf /var/cache/debconf/*-old \
 && rm -rf /var/lib/apt/lists/* \
 && true

RUN usermod -u 26 -g 26 postgres && find / \( -path /dev -o -path /proc \) -prune -uid 999 2>/dev/null -exec chown -R 26:26 '{}' \; && chown -R 26:26 /var/run/postgresql  && chown -R 26:26 /var/lib/postgresql
