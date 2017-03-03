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
var invoiceService = require('../services/invoice_service');

router.get('/:id', validate({
    query: require('../schema/offers_schema').Offers
}), function (req, res, next) {


    queries.GetOfferByID(req.query['userUUID'], req.params['id'], function (err, data) {
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


    var userUUID = req.query['userUUID'];
    var requestData = req.body;

    queries.CreateOfferRequest(userUUID, requestData, function(err, offerRequest) {
        if (err) {
            next(err);
        } else {
            invoiceService.generateInvoiceForRequest(requestData, function (err, invoiceData) {
                if (err) {
                    next(err);
                } else {
                    queries.SetPaymentInvoiceOffer(userUUID, invoiceData, offerRequest.id, function(err, offerId) {
                       if (err) {
                           next(err);
                       } else {
                           var fullUrl = req.protocol + '://' + req.get('host') + req.originalUrl;
                           res.set('Location', fullUrl + offerId);
                           res.status(201);
                           res.json({}); //TODO: Send offer json
                       }
                    });
                }
            });
        }
    });


});

router.post('/:id/payment', validate({
    query: require('../schema/offers_schema').Offers,
    body: require('../schema/offers_schema').Payment
}), function (req, res, next) {


    var userUUID = req.query['userUUID'];
    var paymentData = req.body;
    //TODO: Save payment for offer

    res.sendStatus(200);
});


module.exports = router;