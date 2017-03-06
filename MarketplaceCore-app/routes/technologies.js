/* ##########################################################################
 -- Author: Marcel Ely Gomes
 -- Company: Trumpf Werkzeugmaschine GmbH & Co KG
 -- CreatedAt: 2017-02-27
 -- Description: Routing service for TechnologyData
 -- ##########################################################################*/

var express = require('express');
var router = express.Router();
var logger = require('../global/logger');
var validate = require('express-jsonschema').validate;
var queries = require('../connectors/pg-queries');


router.get('/', validate({query: require('../schema/technologies_schema').Technologies}), function (req, res, next) {
    logger.debug(req);
        queries.GetAllTechnologies(req, res, function(err,data) {
            if (err) {
                next(err);
            }
            else {
                res.json(data);
            }
        });
});

router.get('/:id', validate({query: require('../schema/technologies_schema').Technologies}),  function (req, res, next) {
    logger.debug(req);
    queries.GetTechnologyByID(req.query['userUUID'], req.param['id'], function (err, data) {
        if (err) {
            next(err);
        }
        else {
            res.json(data);
        }
    });
});

router.get('/:name', validate({query: require('../schema/technologies_schema')}),   function (req, res, next) {
    logger.debug(req);
    queries.GetTechnologyByName(req.query['userUUID'], req.param['name'], function (err, data) {
        if (err) {
            next(err);
        }
        else {
            res.json(data);
        }
    });

});

router.post('/technology', validate({query: require('../schema/technologies_schema')}),   function (req, res, next) {
    logger.debug(req);
    queries.CreateTechnology(req,res,next);

});

module.exports = router;