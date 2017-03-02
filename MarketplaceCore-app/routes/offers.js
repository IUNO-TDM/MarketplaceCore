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

router.get('/:id', validate({
    query: require('../schema/offers_schema').Offers
}), function (req, res, next) {
    logger.debug(req);

    queries.GetOfferByID(req.query['userUUID'], req.param['id'], function (err, data) {
        if (err) {
            next(err);
        } else {
            res.json(data);
        }
    });

});

router.post('/', validate({
    query: require('../schema/offers_schema').Offers,
    body: require('../schema/offers_schema').OfferRequestBody
}), function (req, res, next) {
    logger.debug(req);

    var userUUID = req.query['userUUID'];
    var requestData = req.body;
    //TODO: Create offer for request data
    //TODO: Store offer in database
    //TODO: Send offer back to the client
    res.json({});
});

router.post('/:id/payment', validate({
    query: require('../schema/offers_schema').Offers,
    body: require('../schema/offers_schema').Payment
}), function (req, res, next) {
    logger.debug(req);

    var userUUID = req.query['userUUID'];
    var paymentData = req.body;
    //TODO: Save payment for offer

    res.sendStatus(200);
});


module.exports = router;