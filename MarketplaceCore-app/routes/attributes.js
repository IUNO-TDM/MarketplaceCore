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


router.get('/', validate({query: require('../schema/attributes_schema')}), function (req, res, next) {
    logger.debug(req);
        queries.GetAllAttributes(req, res, next);
});

router.get('/attributeuuid/:attributeUUID', validate({query: require('../schema/attributes_schema')}),  function (req, res, next) {
    logger.debug(req);
        queries.GetAttributeByID(req,res,next);

});

router.get('/attributename/:attributeName', validate({query: require('../schema/attributes_schema')}),   function (req, res, next) {
    logger.debug(req);
        queries.GetAttributeByName(req,res,next);

});

router.put('/attribute', validate({query: require('../schema/attributes_schema')}),   function (req, res, next) {
    logger.debug(req);
    queries.CreateAttribute(req,res,next);

});

module.exports = router;