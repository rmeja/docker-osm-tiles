#!/bin/sh

echo "Arrêt des conteneurs"
docker stop osm-web
docker stop pgsql

echo "Suppression des conteneurs"
docker rm osm-web
docker rm pgsql
