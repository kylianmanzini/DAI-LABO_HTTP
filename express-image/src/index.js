var Chance = require('chance');
var chance = new Chance();

var express = require('express');
var app = express();

var port = 3000;

app.get('/', function (req,res){
    res.send("Bonjour " + chance.name() + " " + chance.city());
    console.log("Access to /");
});

app.get('/zoo', function (req,res){
    res.send(getZoo());
    console.log("Access to /zoo");
});

app.listen(port, function (){
    console.log("Http requests port " + port);
});

function getZoo(){
    var zoo = [];
    for (i = 0; i < chance.integer({min: 4, max: 10}); ++i){
        zoo[i] = {
            population: chance.integer({min: 1, max: 10}),
            species : chance.animal(),
            overseer: chance.name(),
            cleaningDay: chance.weekday(),
            feedingDay: chance.weekday(),
            animals: []
        }
        for (j = 0; j < zoo[i].population; ++j){
            zoo[i].animals[j] = {
                name : chance.last(),
                gender : chance.gender(),
                birthday :chance.birthday(
                    { string: true, american: false, year:chance.year({min: 1980, max:2022}) }
                )
            }
        }

    }

    return zoo;
}