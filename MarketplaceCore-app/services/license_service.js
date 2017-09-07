const EventEmitter = require('events').EventEmitter;
const util = require('util');
const payment_service = require('./payment_service');
const config = require('../config/config_loader');
const dbTrans = require('../database/function/transaction');
const dbLicence = require('../database/function/license');
const licenseCentral = require('../adapter/license_central_adapter');
const dbPayment = require('../database/function/payment');
const dbOfferRequest = require('../database/function/offer_request');
const logger = require('../global/logger');
const async = require('async');
const helper = require('../services/helper_service');

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
        async.series([
                function (callback) {
                    dbTrans.GetTransactionByID(config.USER, transactionUuid, function (err, transaction) {
                        if (err) {
                            return callback(err);
                        }
                        if (!err && !transaction.licenseorderuuid) {
                            dbOfferRequest.GetOfferRequestById(transaction.offerrequestuuid, config.USER, function (err, offerRequest) {
                                if (err) {
                                    return callback(err);
                                }

                                for (var key in offerRequest.items) {
                                    const item = offerRequest.items[key];

                                    let shortUUID;
                                    try {
                                        shortUUID = helper.convertUUIDtoBase85(transaction['buyer']);
                                    }
                                    catch (err) {
                                        shortUUID = ''
                                    }

                                    licenseCentral.createAndActivateLicense(offerRequest.hsmid, shortUUID, config.PRODUCT_CODE_PREFIX + item.productcode, item.amount, function (err) {
                                        if (err) {
                                            return callback(err);
                                        }

                                        dbLicence.CreateLicenseOrder(null, transaction.offeruuid, config.USER, function (err, data) {
                                            if (!err) {
                                                license_service.emit('updateAvailable', data.offeruuid, offerRequest.hsmid);
                                            }

                                            callback(err);
                                        });
                                    });
                                }

                            });
                        }
                    });
                }
            ],
            function (err) {
                if (err) {
                    logger.crit('[license_service] Error while create and activate license');
                }
                delete license_service.transaction_queue[transactionUuid];
            });


    }
});


module.exports = license_service;