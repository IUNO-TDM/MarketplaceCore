/* ##########################################################################
 -- Author: Marcel Ely Gomes
 -- Company: Trumpf Werkzeugmaschine GmbH & Co KG
 -- CreatedAt: 2017-02-28
 -- Description: Routing offers requests
 -- ##########################################################################*/

var express = require('express');
var router = express.Router();
var logger = require('../global/logger');
var validate = require('express-jsonschema').validate;
var queries = require('../connectors/pg-queries');

router.get('/', validate({query: require('../schema/offers_schema').Offers}), function (req, res, next) {
    logger.debug(req);
       queries.GetAllOffers(req,res,next);
});

router.get('/offeruuid/:offerUUID', validate({query: require('../schema/offers_schema').Offers}), function (req, res, next) {
    logger.debug(req);

    queries.GetOfferByID(req,res,next);

});

router.get('/offerrequest/:offerRequestUUID', validate({query: require('../schema/offers_schema').Offers}), function (req, res, next) {
    logger.debug(req);

    queries.GetOfferForRequest(req,res,next);

});

module.exports = router;