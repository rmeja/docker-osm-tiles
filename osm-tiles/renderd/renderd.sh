#!/bin/sh

# Démarrage de Renderd
exec /sbin/setuser www-data /usr/local/bin/renderd --config /usr/local/etc/renderd.conf --foreground yes
