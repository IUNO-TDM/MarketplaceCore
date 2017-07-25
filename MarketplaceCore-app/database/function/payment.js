/**
 * Created by beuttlerma on 31.05.17.
 */

var logger = require('../../global/logger');
var db = require('../db_connection');

var self = {};

self.SetPayment = function(userUUID, payment, callback) {
    db.func('SetPayment', [payment.transactionUUID, payment.bitcoinTransaction, payment.confidenceState, payment.depth, payment.extInvoiceId, userUUID])
        .then(function (data) {
            if (data && data.length) {
                data = data[0];
            }
            logger.debug('SetPayment result: ' + JSON.stringify(data));
            callback(null, data);
        })
        .catch(function (error) {
            logger.crit(error);
            callback(error);
        });
};
//</editor-fold>

//<editor-fold desc="PaymentInvoice">
//</editor-fold>

//<editor-fold desc="Offer and Invoice">
self.SetPaymentInvoiceOffer = function (userUUID, roleName, invoice, offerRequestUUID, callback) {
    db.func('SetPaymentInvoiceOffer',
        [   offerRequestUUID,
            invoice,
            userUUID,
            roleName
        ])
        .then(function (data) {
            logger.debug('SetPaymentInvoiceOffer result: ' + JSON.stringify(data));
            callback(null, data);
        })
        .catch(function (error) {
            logger.crit(error);
            callback(error);
        });
};

self.GetPaymentInvoiceForOfferRequest = function(userUUID, offerRequestUUID, callback){
    db.func('GetPaymentInvoiceForOfferRequest', [offerRequestUUID, userUUID])
        .then(function (data) {
            callback(null, data);
        })
        .catch(function (error) {
            logger.crit(error);
            callback(error);
        });
};


module.exports = self;