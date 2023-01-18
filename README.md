# Step 1 - Apache Server


The goal for this part is to create a static HTTP server using apache. We will use docker to create container of the server.

## Dockerfile

Firstly, we need to create a ``Dockerfile``, it will look like this :

```
FROM php:7.2-apache

LABEL authors="Kylian Manzini, Ylli Fazlija"

EXPOSE 9000

COPY src /var/www/html/
```
It will use the image of ``php:7.2-apache``, expose the port that we will use and copy the ``src`` folder from the host to the ``/var/www/html/`` folder in the container.

## Web template

The web template is a simple HTML file with CSS and Javascript. It was found here : https://templatemo.com/tm-467-easy-profile

We simplified it and prepared the content for the next step of the lab by adding ids to HTML tags and changing the default images.

## Get the apache configuration

To get the config file, we need to get it through the bash of the container by using this command :

```
docker exec -i $(docker ps -a -q --filter ancestor=dai/apache) bash -c " cd .. && cd .. && cd .. && cd etc/apache2 && cat apache2.conf"
```

It is a bit to big to type, so we used a ``run.sh`` script to do things faster with docker. You can learn the usage just below. 

## How to use run.sh 

For the step 1 and 2, you will need to execute the ``run.sh`` script at the root of the project to run preset docker commands.

It can be used like this : 

```
./run.sh <image> <action>
```

```
Avaliable image :
dai/apache  *web server apache*
dai/api     *api using node.js*

Avaliable action : 
build       Build the image
start       Start a container of the image
stop        Stop containers of this image

get_conf    Get the configuration of the apache server, only avalible for the dai/apache image
```

Exemple: build the dai/apache image :

```
./run.sh dai/apache build
```
Exemple: get the config of the apache server :

```
./run.sh dai/apache get_conf
```

# Step 2 - Api using express.js

## Dockerfile

This step require building a HTTP server that send a random json payload when we access it. To do that we need to create a new image which will be a node.js server. We will use express.js to get HTTP requests and send responses.

First, we need to create a new ``Dockerfile`` that we will use to build our image. It will look like this: 

```
FROM node:18

LABEL authors="Kylian Manzini, Ylli Fazlija"

EXPOSE 3000

COPY src /opt/app

CMD ["node", "/opt/app/index.js"]
```

We simply get the image from ``node:18``, expose the port we will use, copy the data from ``src`` of the host to the container at ``/opt/app`` and lastly, we start node.js on the ``index.js``.

## Node.js server

``index.js`` is the file in which we do the logic of the server. It look like this: 

```
var Chance = require('chance');
var chance = new Chance();

var express = require('express');
var app = express();

var port = 3000;

app.get('/api', function (req,res){
    res.send(getAnimal());
    console.log("Access to /api from " + req.ip + " " + req.hostname);
});

app.listen(port, function (){
    console.log("Http requests port " + port);
});

function getAnimal(){
    return {
        species: chance.animal(),
        overseer: chance.name(),
        name: chance.last(),
        gender: chance.gender(),
        birthday: chance.birthday(
            {string: true, american: false, year: chance.year({min: 1980, max: 2022})}
        )
    };
}
```

To fetch random data, we will use ``chance.js`` and use ``express.js`` as a framework for our server.

With ``express``, we create a server and assign customs ``.get`` function to it. 

For exemple, ``app.get('/api', ...){...}`` will be executed every time a client want to get the ``/api`` url. In this case, we simply get a ``.json`` containing an animal made from the ``getAnimal()`` function and we send it back to the client.

We also need to listen a port (3000 in our case) where the request will come. We do this with the ``.listen(port, ...){...}`` function.

To run it, the ``run.sh`` bash script can be used the same as with the apache image with the exception of using ``dai/api`` instead of ``dai/apache`` as image.

# Step 3a - Docker compose

To use docker compose, we will need to use to add a ``docker-compose.yml`` file at the root of the project. The file will look like this:

```
version: '3'

services:
  data_api:
    image: dai/api
    build:
      context: express-image
    ports:
      - "9001:3000"

  apache_app:
    image: dai/apache
    build:
      context: apache-image
    ports:
      - "9000:80"
    depends_on:
      - data_api

```

We can specify services that we want to run. In our case, we want to run our apache web server and the api in two containers.

To do that, we first need to specify the services, ``data_api`` will run an image of ``dai/api`` and ``apache_app`` will run an image of ``dai/apache``. We can also specify the ports so we can access to them in the browser.

We then need to use the ``docker compose <action>`` command. 

Using ``build`` will build the images required, ``up`` will create containers and start them and finally ``down`` will stop and delete the containers.

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

# Step 4 - Fetch javascript requests

The goal of this step was to get data from our api and update our website with the data.

We use the ``fetch()`` function in javascript to get our data.

First we need to add a script tag at the end of the ``index.html`` of the apache web server. In this template we have differents HTML tag with set ids, such as ``nom``, ``espece`` or ``status``.

To modify the content, we use functions called ``populateOk(data)`` and ``populateError()``, to add content when we received data from the api and add default content when there is a problem receiving the data. To modify the content, we simply select the correct element by id and modify the content in the populate function, like this:
```
    const nom = document.getElementById('nom'),
    ...
	nom.textContent = ("Name : " + res.name);

```
To get the data, we use this function: 
```
	function populatePage() {
		const fetchPromise = fetch("http://localhost/api");
		console.log(fetchPromise);
		fetchPromise
		.then((response) => {
			if (!response.ok){
				populateError();
				throw new Error(`HTTP error: ${response.status}`);
			}
			return response.json();
		})
		.then((data) => {
			console.log("data received");
			populateOk(data);
		})
		.catch((error) => {
			populateError();
			console.error(`api did not work: ${error}`);
		})
	}
```

It work this way: 

First, we ask data to the api by using ``fetch("http://localhost/api")``. This way, we can get the data from the url, which is our api.

Second, we use the ``.then`` and ``.catch``. The ``.then`` will be triggered when the ``fetch()`` has received an HTTP response from the api. We then need to check if the HTTP response was successfull, which mean the HTTP status code is between 200 and 299. We do that using ``response.ok``. The ``.catch`` will be triggered if there was a problem during the ``fetch()``.

Lastly, we send the payload we received to the populate functions.

To make a request when the page is loaded and every few second, we need to add this code at the end: 

```
	populatePage();
	window.setInterval(populatePage, 6000);
```

It will simply call the function once at the beginning and once every 6 seconds.

# Step 5 - Load balancing and sticky sessions

## Sticky session

The simple way to add a sticky session is to add two simple line to the service we want to stick to the user : 
```
      - traefik.http.services.app.loadbalancer.sticky.cookie=true
      - traefik.http.services.app.loadbalancer.sticky.cookie.name=sticky-cookie
```

In our case, we want the apache web servers to stick. This way, a user will send request to the same server he connected to first.

## Load balancing

By default, traefik does use a round robin load balancing system. So we did not had to change anything for it to work. 

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