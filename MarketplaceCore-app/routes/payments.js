/**
 * Created by elygomesma on 15.02.17.
 */

var express = require('express');
var router = express.Router();
var logger = require('../global/logger');
var marketplaceCore = require('../connectors/dummy_connector');
var helper = require('../services/helper_service');
var validate = require('express-jsonschema').validate;
var pgp = require('pg-promise')();
var db = pgp("postgres://postgres:Trumpf1234@localhost:5432/Test");


router.get('/', function (req, res, next) {
    logger.debug(req);

         db.func('GetAllComponents')
            .then(function(data) {
                res.json(data);
            })
            .catch(function (error) {
                console.log("ERROR:", error.message || error); // print the error;
            });

});

module.exports = router;