# Step 2 - Api using express.js

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