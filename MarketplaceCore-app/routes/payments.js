/**
 * Created by elygomesma on 15.02.17.
 */

var express = require('express');
var router = express.Router();
var logger = require('../global/logger');
var pgp = require('pg-promise')();


router.get('/', function (req, res, next) {


    db.func('GetAllComponents')
        .then(function (data) {
            res.json(data);
        })
        .catch(function (error) {
            console.log("ERROR:", error.message || error); // print the error;
        });

});

module.exports = router;