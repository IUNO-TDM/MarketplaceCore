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
var invoiceService = require('../services/invoice_service');
var helper = require('../services/helper_service');
var Offer = require('../database/model/offer');
var offerRequest = require('../database/function/offer_request');
var payment = require('../database/function/payment');
var transaction = require('../database/function/transaction');

router.get('/:id', validate({
    query: require('../schema/offers_schema').Offers
}), function (req, res, next) {
    new Offer().FindSingle(req.query['userUUID'], req.params['id'], function (err, data) {
        if (err) {
            next(err);
        } else {
            res.json(data);
        }
    });

});



//
// Those routes are not REST like and I'm not sure if they are even used some where. Let's see if someone complains
//


// router.get('/offerrequest/:id', validate({
//     query: require('../schema/offers_schema').Offers
// }), function (req, res, next) {
//     new Offer().FindByRequest(req.query['userUUID'], req.params['id'], function (err, data) {
//         if (err) {
//             next(err);
//         } else {
//             res.json(data);
//         }
//     });
//
// });
//
// router.get('/paymentinvoice/:id', validate({
//     query: require('../schema/offers_schema').Offers
// }), function (req, res, next) {
//     new Offer().FindByPaymentInvoice(req.query['userUUID'], req.params['id'], function (err, data) {
//         if (err) {
//             next(err);
//         } else {
//             res.json(data);
//         }
//     });
// });

router.post('/', validate({
    query: require('../schema/offers_schema').Offers,
    body: require('../schema/offers_schema').OfferRequestBody
}), function (req, res, next) {

    var userUUID = req.query['userUUID'];
    var requestData = req.body;
    var roleName = req.token.user.rolename;

    offerRequest.CreateOfferRequest(userUUID, roleName, requestData, function (err, offerRequest) {
        if (err) {
            next(err);
        } else {
            if (!offerRequest || offerRequest.length <= 0) {
                next(new Error('Error when creating offer request in marketplace'));
            }else{
                transaction.GetTransactionByOfferRequest(userUUID, roleName, offerRequest.result.offerrequestuuid, function (err, transaction) {
                    if (err) {
                        next(err);
                    } else {
                        invoiceService.generateInvoice(offerRequest[0], transaction[0], function (err, invoiceData) {
                            if (err) {
                                next(err);
                            } else {
                                payment.SetPaymentInvoiceOffer(userUUID, roleName, invoiceData, offerRequest.result.offerrequestuuid, function (err, offer) {
                                    if (err) {
                                        next(err);
                                    } else {
                                        var fullUrl = helper.buildFullUrlFromRequest(req);
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
        }
    });


});

module.exports = router;