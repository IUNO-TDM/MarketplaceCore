const EventEmitter = require('events').EventEmitter;
const util = require('util');
const payment_service = require('./payment_service');
const config = require('../config/config_loader');
const dbTrans = require('../database/function/transaction');
const dbLicence = require('../database/function/license');
const licenseCentral = require('../adapter/license_central_adapter');
const dbPayment = require('../database/function/payment');
const dbOfferRequest = require('../database/function/offer_request');

const LicenseService = function () {
    this.transaction_queue = {};
};
const license_service = new LicenseService();
util.inherits(LicenseService, EventEmitter);


payment_service.on('StateChange', function (data) {
    const transactionUuid = data.invoice.referenceId;
    if (data.payment && data.payment.paydate) {

        if (license_service.transaction_queue[transactionUuid]) {
            return
        }

        license_service.transaction_queue[transactionUuid] = true;

        dbTrans.GetTransactionByID(config.USER, transactionUuid, function (err, transaction) {
            if (!err && !transaction.licenseorderuuid) {

                dbOfferRequest.GetOfferRequestById(transaction.offerrequestuuid, config.USER, function (err, offerRequest) {

                    offerRequest.items.
                    licenseCentral.createAndActivateLicense(offerRequest.hsmId, transaction.buyer, itemId, quantity, function(err, success) {

                        dbLicence.CreateLicenseOrder(null, transaction.offeruuid, config.USER, function (err, data) {
                            if (!err) {
                                license_service.emit('updateAvailable', data.offeruuid, cmSerial);
                            }
                        });
                    });
                });
            }
        });
    }
});


module.exports = license_service;