FROM phusion/baseimage:0.9.17
MAINTAINER Rémy MEJA <remy.meja@univ-lorraine.fr>

ENV DEBIAN_FRONTEND noninteractive

# Mise à jour du système
RUN apt-get update
RUN apt-get -y dist-upgrade

# Installation des paquets necessaires
RUN apt-get -y install g++ make expat libexpat1-dev zlib1g-dev apache2 wget

# Installation d'Overpass
WORKDIR /opt
RUN wget http://dev.overpass-api.de/releases/osm-3s_v0.7.52.tar.gz
RUN tar xzvf osm-3s_v0.7.52.tar.gz
WORKDIR /opt/osm-3s_v0.7.52
RUN ./configure CXXFLAGS="-O3" --prefix=/usr/local
RUN make install

# Configuration d'Apache
RUN a2enmod cgi
RUN a2enmod ext_filter
WORKDIR /etc/apache2/sites-available
COPY apache/000-default.conf 000-default.conf

# Configuration Overpass
WORKDIR /opt
RUN wget http://download.geofabrik.de/europe/france/lorraine-latest.osm.bz2
RUN mkdir overpass-data
RUN osm-3s_v0.7.52/bin/init_osm3s.sh lorraine-latest.osm.bz2 overpass-data osm-3s_v0.7.52 --meta

# Ajout d'Apache dans runit
RUN mkdir /etc/service/apache
COPY apache/apache.sh /etc/service/apache/run

# Ajout d'Overpass-dispatcher dans runit
RUN mkdir /etc/service/overpass-dispatcher
COPY overpass-dispatcher/overpass-dispatcher.sh /etc/service/overpass-dispatcher/run

WORKDIR /

EXPOSE 80

CMD ["/sbin/my_init"]
