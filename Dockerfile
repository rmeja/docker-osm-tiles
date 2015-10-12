FROM phusion/baseimage:0.9.17
MAINTAINER Rémy MEJA <remy.meja@univ-lorraine.fr>

ENV DEBIAN_FRONTEND noninteractive

# Mise à jour du système
RUN apt-get update
RUN apt-get -y dist-upgrade

# Installation des dépendances necessaires pour la suite des opérations
RUN apt-get -y install libboost-all-dev subversion git tar unzip wget bzip2 build-essential autoconf libtool \
libxml2-dev libgeos-dev libgeos++-dev libpq-dev libbz2-dev libproj-dev munin-node munin libprotobuf-c0-dev \
protobuf-c-compiler libfreetype6-dev libpng12-dev libtiff4-dev libicu-dev libgdal-dev libcairo-dev \
libcairomm-1.0-dev apache2 apache2-dev libagg-dev liblua5.2-dev ttf-unifont lua5.1 liblua5.1-dev node-carto \
g++ make expat libexpat1-dev zlib1g-dev

# Installation de PostgreSQL et de PostGIS
RUN apt-get -y install postgresql postgresql-contrib postgis postgresql-9.3-postgis-2.1

# Installation de osm2pgsql
WORKDIR /opt
RUN git clone git://github.com/openstreetmap/osm2pgsql.git
WORKDIR /opt/osm2pgsql
RUN ./autogen.sh
RUN ./configure
RUN make
RUN make install

# Installation de la bibliothèque Mapnik
WORKDIR /opt
RUN git clone git://github.com/mapnik/mapnik
WORKDIR /opt/mapnik
RUN git branch 2.2 origin/2.2.x
RUN git checkout 2.2
RUN python scons/scons.py configure INPUT_PLUGINS=all OPTIMIZATION=3 SYSTEM_FONTS=/usr/share/fonts/truetype/
RUN make
RUN make install
RUN ldconfig

# Installation de mod_tile et renderd
WORKDIR /opt
RUN git clone git://github.com/openstreetmap/mod_tile.git
WORKDIR /opt/mod_tile
RUN ./autogen.sh
RUN ./configure
RUN make
RUN make install
RUN make install-mod_tile
RUN ldconfig

# Installation d'Overpass
WORKDIR /opt
RUN wget http://dev.overpass-api.de/releases/osm-3s_v0.7.52.tar.gz
RUN tar -zxvf osm-3s_v0.7.52.tar.gz
WORKDIR /opt/osm-3s_v0.7.52
RUN ./configure CXXFLAGS="-O3" --prefix=/usr/local
RUN make install

# Installation d'OSM Bright
RUN mkdir -p /usr/local/share/maps/style
WORKDIR /usr/local/share/maps/style
RUN wget https://github.com/mapbox/osm-bright/archive/master.zip
RUN wget http://data.openstreetmapdata.com/simplified-land-polygons-complete-3857.zip
RUN wget http://data.openstreetmapdata.com/land-polygons-split-3857.zip
RUN wget http://www.naturalearthdata.com/http//www.naturalearthdata.com/download/10m/cultural/ne_10m_populated_places_simple.zip
RUN unzip master.zip
RUN unzip simplified-land-polygons-complete-3857.zip
RUN unzip land-polygons-split-3857.zip
RUN unzip ne_10m_populated_places_simple.zip -d ne_10m_populated_places_simple
RUN mkdir osm-bright-master/shp
RUN mv land-polygons-split-3857 osm-bright-master/shp/
RUN mv simplified-land-polygons-complete-3857 osm-bright-master/shp/
RUN mv ne_10m_populated_places_simple osm-bright-master/shp/
WORKDIR /usr/local/share/maps/style/osm-bright-master/shp/land-polygons-split-3857
RUN shapeindex land_polygons.shp
WORKDIR /usr/local/share/maps/style/osm-bright-master/shp/simplified-land-polygons-complete-3857/
RUN shapeindex simplified_land_polygons.shp
WORKDIR /usr/local/share/maps/style/osm-bright-master/shp/

# Configuration d'OSM Bright
WORKDIR /usr/local/share/maps/style/osm-bright-master/osm-bright
RUN rm osm-bright.osm2pgsql.mml
COPY osm-bright.osm2pgsql.mml osm-bright.osm2pgsql.mml

# Compilation des feuilles de style
WORKDIR /usr/local/share/maps/style/osm-bright-master
COPY configure.py configure.py
RUN ./make.py
WORKDIR /usr/local/share/maps/style/OSMBright
RUN carto project.mml > OSMBright.xml

# Configuration de renderd
RUN rm /usr/local/etc/renderd.conf
COPY renderd/renderd.conf /usr/local/etc/renderd.conf
RUN mkdir /var/run/renderd
RUN chown www-data /var/run/renderd
RUN mkdir /var/lib/mod_tile
RUN chown www-data /var/lib/mod_tile

# Configuation de mod_tile
COPY apache/mod_tile.conf /etc/apache2/conf-available/mod_tile.conf
RUN rm /etc/apache2/sites-available/000-default.conf
COPY apache/000-default.conf /etc/apache2/sites-available/000-default.conf
RUN a2enconf mod_tile

# Chargement des données d'OpenStreetMap
RUN mkdir /usr/local/share/maps/france
WORKDIR /usr/local/share/maps/france
RUN wget http://download.geofabrik.de/europe/france/lorraine-latest.osm.pbf

# Ajout du fichier d'example pour Apache
WORKDIR /var/www/html
RUN rm index.html
COPY apache/index.html index.html

# Ajout de PostgreSQL dans runit
RUN touch /first_start
RUN mkdir /etc/service/postgresql
ADD postgresql/postgresql.sh /etc/service/postgresql/run

# Ajout de Renderd dans runit
RUN mkdir /etc/service/renderd
ADD renderd/renderd.sh /etc/service/renderd/run

# Ajout d'Apache dans runit
RUN mkdir /etc/service/apache
ADD apache/apache.sh /etc/service/apache/run

WORKDIR /

EXPOSE 80

CMD ["/sbin/my_init"]
