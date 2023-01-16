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