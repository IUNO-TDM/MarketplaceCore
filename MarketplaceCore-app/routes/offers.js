/* ##########################################################################
 -- Author: Marcel Ely Gomes
 -- Company: Trumpf Werkzeugmaschine GmbH & Co KG
 -- CreatedAt: 2017-02-28
 -- Description: Routing offers requests
 -- ##########################################################################*/

const express = require('express');
const router = express.Router();
const logger = require('../global/logger');

const {Validator, ValidationError} = require('express-json-validator-middleware');
const validator = new Validator({allErrors: true});
const validate = validator.validate;
const validation_schema = require('../schema/offers_schema');

const invoiceService = require('../services/invoice_service');
const helper = require('../services/helper_service');
const Offer = require('../database/model/offer');
const dbOfferRequest = require('../database/function/offer_request');
const payment = require('../database/function/payment');
const dbTransaction = require('../database/function/transaction');
const dbLicense = require('../database/function/license');
const licenseService = require('../services/license_service');
const bruteForceProtection = require('../services/brute_force_protection');
const paymentService = require('../services/payment_service');

router.get('/:id', validate({
    query: validation_schema.Empty,
    body: validation_schema.Empty
}), function (req, res, next) {
    new Offer().FindSingle(req.token.user.id, req.token.user.roles, req.params['id'], function (err, data) {
        if (err) {
            next(err);
        } else {
            res.json(data);
        }
    });

});

router.post('/', bruteForceProtection.global,
    validate({
        query: validation_schema.Empty,
        body: validation_schema.OfferRequestBody
    }), function (req, res, next) {

        const userUUID = req.token.user.id;
        const clientUUID = req.token.client.id;
        const requestData = req.body;
        const roles = req.token.user.roles;

        dbOfferRequest.CreateOfferRequest(userUUID, clientUUID, roles, requestData, function (err, offerRequest) {
            if (err) {
                next(err);
            } else {
                if (!offerRequest || offerRequest.length <= 0) {
                    next(new Error('Error when creating offer request in marketplace'));
                } else {
                    dbTransaction.GetTransactionByOfferRequest(userUUID, roles, offerRequest.result.offerrequestuuid, function (err, transaction) {
                        if (err) {
                            next(err);
                        } else {
                            invoiceService.generateInvoice(userUUID, offerRequest, transaction, roles, function (err, invoiceData) {
                                if (err) {
                                    next(err);
                                } else {
                                    payment.SetPaymentInvoiceOffer(userUUID, roles, invoiceData, offerRequest.result.offerrequestuuid, function (err, offer) {
                                        if (err) {
                                            next(err);
                                        } else {
                                            const fullUrl = helper.buildFullUrlFromRequest(req);
                                            res.set('Location', fullUrl + offer[0].offeruuid);
                                            res.status(201);
                                            const invoiceIn = JSON.parse(offer[0].invoice);
                                            const invoiceOut = {
                                                expiration: invoiceIn.expiration,
                                                transfers: invoiceIn.transfers
                                            };
                                            paymentService.getInvoiceBip21(invoiceIn, (err, bip21) => {
                                                if (err) {
                                                    logger.crit(err);
                                                }

                                                res.json({
                                                    id: offer[0].offeruuid,
                                                    invoice: invoiceOut,
                                                    bip21: bip21
                                                });
                                            });
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

router.post('/:offer_id/request_license_update',
    bruteForceProtection.global,
    validate({
        query: validation_schema.Empty,
        body: validation_schema.RequestLicenseUpdateBody
    }), function (req, res, next) {


        const offerUUID = req.params['offer_id'];
        const hsmId = req.body['hsmId'];
        const userUUID = req.token.user.id;
        const roles = req.token.user.roles;

        dbTransaction.GetTransactionByOffer(userUUID, roles, offerUUID, (err, transaction) => {
            if (err) {
                return next(err);
            }

            if (!transaction || !transaction['licenseorderuuid'] || transaction['licenseorderuuid'].length <= 0) {
                return res.sendStatus(404);
            }

            licenseService.emit('updateAvailable', offerUUID, hsmId);

            res.sendStatus(200);
        });
    });

module.exports = router;