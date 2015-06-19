#!/bin/bash
if [ "${1:-}" = "build" ] ; then
shift
ORACLE_FDW_VERSION=${1:-1.2.0} \
 && wget --quiet "https://codeload.github.com/laurenz/oracle_fdw/tar.gz/ORACLE_FDW_$(echo $ORACLE_FDW_VERSION | sed 's/\./_/g')" -O fdw.tar.gz 1>&2 \
 && tar zxf fdw.tar.gz 1>&2 \
 && mv oracle_fdw-* oracle_fdw 1>&2 \
 && cd oracle_fdw 1>&2 \
 && ORACLE_HOME=/usr/local/instantclient LD_LIBRARY_PATH=/usr/local/instantclient make 1>&2 \
 && ORACLE_HOME=/usr/local/instantclient LD_LIBRARY_PATH=/usr/local/instantclient make install DESTDIR=/opt/target 1>&2 \
 && true 1>&2
 mkdir /tmp/target 
 cd /tmp/target ; fpm -s dir -t deb -v $ORACLE_FDW_VERSION -n oracle_fdw /opt/target/usr=/ 1>&2
 cd /tmp ; tar czf - target | cat
 exit
fi
exec "$@"
