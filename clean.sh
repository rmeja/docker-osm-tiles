#!/bin/sh

echo "Arrêt des conteneurs"
docker stop tile-render
docker stop pgsql

echo "Suppression des conteneurs"
docker rm tile-render
docker rm pgsql
