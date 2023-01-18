# Step 3b - Traefik and dynamic clusters

## Traefik

Traefik is a reverse proxy that can be used to redirect client requests to the right server. To add Traefik to our project, we simply need to add it as a new service in our  ``docker-compose.yml``, like this

```
  traefik:
    image: traefik
    container_name: reverse_proxy
    command:
      - --api.dashboard=true
      - --api.insecure=true
      - --providers.docker=true
    ports:
      - "80:80"
      - "8080:8080"

    labels:
      - traefik.enable=true

    volumes:
      - /var/run/docker.sock:/var/run/docker.sock
```
In our case, we want to activate the Traefik dashbord, which can be accessed at ``localhost:8080/dashboard``.

We also need to add labels to our existing services to specify the path at which the service can be accessed. It looks like this :

```
    //apache server
    - traefik.http.routers.app.rule=Host(`localhost`)
      
    //api
    - traefik.http.routers.data_api.rule=Host(`localhost`) && PathPrefix(`/api`)
```
With this configuration, Traefik will redirect the client requests to the good servers.

## Dynamic clusters

To be working with multiple instances of our services, we need to modify the ``docker-compose.yml`` by adding those two lines in the services we want to scale : 
```
    deploy:
      replicas: 3
```
We also doesn't need anymore to specify the ports since traefik will distribute load between each instances.

The final ``docker-compose.yml`` will look like this.

```
version: '3'

services:
  traefik:
    image: traefik
    container_name: reverse_proxy
    command:
      - --api.dashboard=true
      - --api.insecure=true
      - --providers.docker=true
    ports:
      - "80:80"
      - "8080:8080"

    labels:
      - traefik.enable=true

    volumes:
      - /var/run/docker.sock:/var/run/docker.sock

  data_api:
    image: dai/api
    build:
      context: express-image
    deploy:
      replicas: 3
    labels:
      - traefik.http.routers.data_api.rule=Host(`localhost`) && PathPrefix(`/api`)

    depends_on:
      - traefik

  apache_app:
    image: dai/apache
    build:
      context: apache-image
    deploy:
      replicas: 3
    labels:
      - traefik.http.routers.app.rule=Host(`localhost`)
    depends_on:
      - data_api
      - traefik
```