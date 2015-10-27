# docker-osm-tiles
Ce dépôt contient toutes les instructions pour monter un serveur de fond de cartes OpenStreetMap en utilisant les conteneurs Docker. Toutes les informations proviennent du tutoriel de [Switch2OSM.org](https://switch2osm.org/fr/servir-des-tuiles/mettre-en-place-manuellement-un-serveur-de-tuiles-14-04/).

Toutes les images Docker présentent dans ce dépot tournent sur Ubuntu 14.04 et se basent sur [phusion/base-image](https://github.com/phusion/baseimage-docker)

## Installation
~~~
git clone https://github.com/rmeja/docker-osm-tiles.git
cd docker-osm-tiles
./build.sh
~~~

Il suffit de consulter l'url suivante http://localhost:8080 pour accéder à la page de démonstration. Par défaut, seule la région Lorraine est chargé dans la base de données PostgreSQL. 



