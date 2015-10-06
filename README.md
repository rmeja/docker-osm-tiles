# docker-osm-tiles
Serveur de fond de cartes OpenStreetMap (en developpement)

## Création de l'image
```
docker build -t rmeja/osm-tiles .
```

## Création de mon conteneur
```
docker run -d -p 8484:80 rmeja/osm-tiles:latest
```

## A faire :
- Différer le demarrage d'Apache et de Renderd apres que le remplissage de la base de données soit finis (osmpgsql)
