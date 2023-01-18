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