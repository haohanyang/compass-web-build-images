# Docker Images for MongoDB Compass Web

Docker images of MongoDB Compass web. The images are experimental and not ready for production.

![screenshot](/static/screenshot.png)

## Quick start
* Docker cli
```
docker run -it --rm -p 7777:7777 -p 1337:1337 haohanyang/compass-web
```
* Docker Compose
```yaml
services:
  compass:
    image: haohanyang/compass-web
    container_name: compass-web-dev-compass
    depends_on:
      - mongo
    ports:
      - 7777:7777
      - 1337:1337
    networks:
      - compass-web-dev

  mongo:
    image: mongo
    container_name: compass-web-dev-mongo
    networks:
      - compass-web-dev

networks:
  compass-web-dev:
    driver: bridge
```