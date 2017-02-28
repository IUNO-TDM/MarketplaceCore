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
        queries.GetAllTechnologies(req, res, next);
});

router.get('/technologyuuid/:technologyUUID', validate({query: require('../schema/technologies_schema').Technologies}),  function (req, res, next) {
    logger.debug(req);
        queries.GetTechnologyByID(req,res,next);

});

router.get('/technologyname/:technologyName', validate({query: require('../schema/technologies_schema')}),   function (req, res, next) {
    logger.debug(req);
        queries.GetTechnologyByName(req,res,next);

});

router.put('/technology', validate({query: require('../schema/technologies_schema')}),   function (req, res, next) {
    logger.debug(req);
    queries.CreateTechnology(req,res,next);

});

module.exports = router;