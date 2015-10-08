# docker-osm-tiles
Serveur de fond de cartes OpenStreetMap (en developpement)

## Création de l'image
```
docker build -t rmeja/osm-tiles .
```

## Création du conteneur
```
docker run -d -p 8484:80 rmeja/osm-tiles:latest
```

## A faire :
- Mettre PostgreSQL dans un autre conteneur Docker afin de mieux gérer l'import des data avec osm2pgsql
