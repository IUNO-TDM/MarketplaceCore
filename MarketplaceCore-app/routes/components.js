/* ##########################################################################
 -- Author: Marcel Ely Gomes
 -- Company: Trumpf Werkzeugmaschine GmbH & Co KG
 -- CreatedAt: 2017-02-28
 -- Description: Routing requests for components
 -- ##########################################################################*/

var express = require('express');
var router = express.Router();
var logger = require('../global/logger');
var validate = require('express-jsonschema').validate;
var queries = require('../connectors/pg-queries');


router.get('/', validate({query: require('../schema/components_schema').Components}), function (req, res, next) {
    logger.debug(req);

    queries.GetAllComponents(req,res,next);

});

router.get('/componentuuid/:componentUUID', validate({query: require('../schema/components_schema').Components}), function (req, res, next) {
    logger.debug(req);

    queries.GetComponentByID(req,res,next);

});

router.get('/componentname/:componentName', validate({query: require('../schema/components_schema').Components}), function (req, res, next) {
    logger.debug(req);

    queries.GetComponentByName(req,res,next);

});


router.put('/component', validate({query: require('../schema/components_schema').SetComponent}), function (req, res, next) {
    logger.debug(req);

    queries.SetComponent(req,res,next);

});

module.exports = router;