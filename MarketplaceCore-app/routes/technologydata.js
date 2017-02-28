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


router.get('/', validate({query: require('../schema/technologydata_schema').TechnologyData}), function (req, res, next) {
    logger.debug(req);
        queries.GetAllTechnologyData(req, res, next);
});

router.get('/parameters/', validate({query: require('../schema/technologydata_schema').TechnologyDataParameters}), function (req, res, next) {
    logger.debug(req);
        queries.GetTechnologyDataByParams(req,res,next);

});

router.get('/technologydatauuid/:technologyDataUUID', validate({query: require('../schema/technologydata_schema')}),  function (req, res, next) {
    logger.debug(req);
        queries.GetTechnologyDataByID(req,res,next);

});

router.get('/technologydataname/:technologyDataName', validate({query: require('../schema/technologydata_schema')}),   function (req, res, next) {
    logger.debug(req);
        queries.GetTechnologyDataByName(req,res,next);

});

router.put('/technologydata', validate({query: require('../schema/technologydata_schema').SetTechnologyData}),   function (req, res, next) {
    logger.debug(req);
    queries.SetTechnologyData(req,res,next);
});

module.exports = router;