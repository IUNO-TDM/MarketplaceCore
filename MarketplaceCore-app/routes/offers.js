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

router.get('/offerrequest/:id', validate({
    query: require('../schema/offers_schema').Offers
}), function (req, res, next) {
    queries.GetOfferForRequest(req.query['userUUID'], req.params['id'], function (err, data) {
        if (err) {
            next(err);
        } else {
            res.json(data);
        }
    });

});

router.get('/paymentinvoice/:id', validate({
    query: require('../schema/offers_schema').Offers
}), function (req, res, next) {
    queries.GetOfferForPaymentInvoice(req.query['userUUID'], req.params['id'], function (err, data) {
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

    queries.CreateOfferRequest(userUUID, requestData, function (err, offerRequest) {
        if (err) {
            next(err);
        } else {
            if (!offerRequest || offerRequest.length <= 0) {
                next({
                    statusCode: 500,
                    message: 'Error when creating offer request in marketplace'
                });
            }

            queries.GetTransactionByOfferRequest(userUUID, offerRequest[0].offerrequestuuid, function (err, transaction) {
                if (err) {
                    next(err);
                } else {
                    invoiceService.generateInvoice(offerRequest[0], transaction[0], function (err, invoiceData) {
                        if (err) {
                            next(err);
                        } else {
                            queries.SetPaymentInvoiceOffer(userUUID, invoiceData, offerRequest[0].offerrequestuuid, function (err, offer) {
                                if (err) {
                                    next(err);
                                } else {
                                    var fullUrl = req.protocol + '://' + req.get('host') + req.baseUrl;
                                    res.set('Location', fullUrl + '/'  +offer[0].offeruuid);
                                    res.status(201);
                                    var invoiceIn  = JSON.parse(offer[0].invoice);
                                    var invoiceOut = {
                                        expiration: invoiceIn.expiration,
                                        transfers: invoiceIn.transfers
                                    };
                                    res.json({'id': offer[0].offeruuid, 'invoice': invoiceOut});
                                }
                            });
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