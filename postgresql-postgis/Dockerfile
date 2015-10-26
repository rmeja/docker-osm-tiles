FROM phusion/baseimage:0.9.17
MAINTAINER Rémy MEJA <remy.meja@univ-lorraine.fr>

ENV DEBIAN_FRONTEND noninteractive

# Mise à jour du système
RUN apt-get update
RUN apt-get -y dist-upgrade

# Installation des dépendances necessaires pour la suite des opérations
RUN apt-get -y install autoconf automake libtool make g++ pkg-config libboost-dev \
  libboost-system-dev libboost-filesystem-dev libboost-thread-dev libexpat1-dev \
  libgeos-dev libgeos++-dev libpq-dev libbz2-dev libproj-dev zlib1g-dev \
  lua5.2 liblua5.2-dev wget

# Installation de PostgreSQL et de PostGIS
RUN apt-get -y install postgresql postgresql-contrib postgis postgresql-9.3-postgis-2.1 git

# Installation de osm2pgsql
WORKDIR /opt
RUN git clone git://github.com/openstreetmap/osm2pgsql.git
WORKDIR /opt/osm2pgsql
RUN ./autogen.sh
RUN ./configure
RUN make
RUN make install

# Chargement des données d'OpenStreetMap
RUN mkdir -p /usr/local/share/maps/france
WORKDIR /usr/local/share/maps/france
RUN wget http://download.geofabrik.de/europe/france/lorraine-latest.osm.pbf

# Ajout de PostgreSQL dans runit
RUN touch /first_start
RUN mkdir /etc/service/postgresql
COPY postgresql.sh /etc/service/postgresql/run

WORKDIR /

CMD ["/sbin/my_init"]
