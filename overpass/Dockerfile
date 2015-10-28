FROM phusion/baseimage:0.9.17
MAINTAINER Rémy MEJA <remy.meja@univ-lorraine.fr>

ENV DEBIAN_FRONTEND noninteractive

# Mise à jour du système
RUN apt-get update
RUN apt-get -y dist-upgrade

# Installation des dépendances necessaires
RUN apt-get -y install g++ make expat libexpat1-dev zlib1g-dev

# Installation d'Overpass
WORKDIR /opt
RUN wget http://dev.overpass-api.de/releases/osm-3s_v0.7.52.tar.gz
RUN tar xzvf osm-3s_v0.7.52.tar.gz
WORKDIR /opt/osm-3s_v0.7.52
RUN ./configure CXXFLAGS="-O3" --prefix=/usr/local
RUN make install

WORKDIR /

CMD ["/sbin/my_init"]
