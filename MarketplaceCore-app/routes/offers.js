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

         db.func('GetAllOffers')
            .then(function(data) {
                res.json(data);
            })
            .catch(function (error) {
                console.log("ERROR:", error.message || error); // print the error;
            });
});

router.get('/:offerID', function (req, res, next) {
    logger.debug(req);

    var offerID = req.params['offerID'];
    db.func('GetOffersByID', [offerID])
        .then(function(data) {
            res.json(data);
        })
        .catch(function (error) {
            console.log("ERROR:", error.message || error); // print the error;
        });

});

router.post('/:offerRequestID', function (req, res, next) {
    logger.debug(req);

    var offerRequestID = req.params['offerRequestID'];
    db.func('CreateOfferForRequest', [offerRequestID])
        .then(function(data) {
            res.json(data);
        })
        .catch(function (error) {
            console.log("ERROR:", error.message || error); // print the error;
        });

});

module.exports = router;