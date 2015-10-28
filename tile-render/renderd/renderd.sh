#!/bin/sh

if [ -f /etc/service/renderd/first_start ]; then
  cd /usr/local/share/maps/style/osm-bright-master/
  sed -i "$(grep -n host configure.py | cut -d':' -f1)s/\"\"/\"$PGSQL_PORT_5432_TCP_ADDR\"/" configure.py
  ./make.py
  cd /usr/local/share/maps/style/OSMBright
  carto project.mml > OSMBright.xml
  rm /etc/service/renderd/first_start
fi

# Démarrage de Renderd
exec /sbin/setuser www-data /usr/local/bin/renderd --config /usr/local/etc/renderd.conf --foreground yes
