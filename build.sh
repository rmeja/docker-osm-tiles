#!/bin/sh

echo "Construction des images"
docker build -t rmeja/tile-render:latest tile-render/.
docker build -t rmeja/pgsql:latest pgsql/.

echo "Démarrage du conteneur PostgreSQL"
docker run -d --name pgsql rmeja/pgsql:latest
sleep 10

echo "Remplissage de la base de données GIS"
docker exec -it pgsql setuser postgres osm2pgsql -k --slim -d gis -C 8000 --number-processes 3 /usr/local/share/maps/france/lorraine-latest.osm.pbf

echo "Démarrage du conteneur Apache/mod_tiles"
docker run -d -p 8080:80 --name tile-render --link pgsql rmeja/tile-render:latest
