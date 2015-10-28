FROM phusion/baseimage:0.9.17
MAINTAINER Rémy MEJA <remy.meja@univ-lorraine.fr>

ENV DEBIAN_FRONTEND noninteractive

# Mise à jour du système
RUN apt-get update
RUN apt-get -y dist-upgrade

# Installation des dépendances necessaires pour la suite des opérations
RUN apt-get -y install autoconf automake libtool make g++ libboost-dev \
  libboost-system-dev libboost-filesystem-dev libboost-thread-dev libxml2-dev \
  libgeos-dev libgeos++-dev libpq-dev libbz2-dev libproj-dev \
  protobuf-c-compiler libprotobuf-c0-dev lua5.2 liblua5.2-dev wget git

# Installation de PostgreSQL et de PostGIS
RUN apt-get -y install postgresql postgresql-contrib postgis postgresql-9.3-postgis-2.1

# Configuration de PostgreSQL
RUN echo "host gis www-data 0.0.0.0/0 trust" >> /etc/postgresql/9.3/main/pg_hba.conf
RUN echo "listen_addresses='*'" >> /etc/postgresql/9.3/main/postgresql.conf

# Installation de osm2pgsql
WORKDIR /opt
RUN git clone git://github.com/openstreetmap/osm2pgsql.git
WORKDIR /opt/osm2pgsql
RUN git checkout 0.88.1
RUN ./autogen.sh
RUN ./configure
RUN make
RUN make install

# Chargement des données d'OpenStreetMap
RUN mkdir -p /usr/local/share/maps/france
WORKDIR /usr/local/share/maps/france
RUN wget http://download.geofabrik.de/europe/france/lorraine-latest.osm.pbf

# Optimisation de PostgreSQL
RUN sed -i -e "s/shared_buffers = 24MB/shared_buffers = 128MB/" \
  -e "s/#checkpoint_segments = 3/checkpoint_segments = 20/" \
  -e "s/#maintenance_work_mem = 16MB/maintenance_work_mem = 256MB/" \
  -e "s/#autovacuum = on/autovacuum = off/" \
  /etc/postgresql/9.3/main/postgresql.conf

# Ajout de PostgreSQL dans runit
RUN mkdir /etc/service/postgresql
RUN touch /etc/service/postgresql/first_start
COPY postgresql.sh /etc/service/postgresql/run

EXPOSE 5432

WORKDIR /

CMD ["/sbin/my_init"]
