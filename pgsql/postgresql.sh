#!/bin/bash

if [ -f /etc/service/postgresql/first_start ]; then
  /etc/init.d/postgresql start
  /sbin/setuser postgres createuser -s www-data
  /sbin/setuser postgres createdb -E UTF8 -O www-data gis
  /sbin/setuser postgres psql -d gis -c 'CREATE EXTENSION POSTGIS;'
  /sbin/setuser postgres psql -d gis -c 'CREATE EXTENSION HSTORE;'
  /sbin/setuser postgres psql -d gis -c 'ALTER TABLE geometry_columns OWNER TO "www-data";'
  /sbin/setuser postgres psql -d gis -c 'ALTER TABLE spatial_ref_sys OWNER TO "www-data";'
  /etc/init.d/postgresql stop
  rm /etc/service/postgresql/first_start
fi

# Start PostgreSQL
exec /sbin/setuser postgres /usr/lib/postgresql/9.3/bin/postgres \
  -D /var/lib/postgresql/9.3/main \
  -c config_file=/etc/postgresql/9.3/main/postgresql.conf
