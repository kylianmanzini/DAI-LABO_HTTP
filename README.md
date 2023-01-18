# Step 6 - Management UI

 With some search on google, we have found a existing web UI to manage docker containers. 
 
 We use docker-web-gui (https://github.com/rakibtg/docker-web-gui). It is a simple yet effective tool to manage the project containers.

 We also have found a docker image of this tool on docker hub (https://hub.docker.com/r/kaive/docker-web-gui). 

 With this docker image, it was really simple to use it by simply adding the management UI as a services in the ``docker-compose.yml``, like this :

 ```
  docker-web-gui:
    image: kaive/docker-web-gui
    container_name: docker_management_ui
    volumes:
      - /var/run/docker.sock:/var/run/docker.sock
    labels:
      - traefik.http.routers.docker-web-gui.rule=Host(`manage.localhost`)
```

When we run ``docker compose up``, it will automaticly be run as a container within our project container stack. Adding the last line allow us to assess the UI by using ``manage.localhost`` as URL.

With this tool, you can stop and start containers, delete them and start new containers based on the image.