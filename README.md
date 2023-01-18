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

