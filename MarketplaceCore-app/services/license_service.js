const EventEmitter = require('events').EventEmitter;
const util = require('util');
const payment_service = require('./payment_service');
const config = require('../config/config_loader');
const dbTrans = require('../database/function/transaction');
const dbLicence = require('../database/function/license');
const licenseCentral = require('../adapter/license_central_adapter');
const dbPayment = require('../database/function/payment');

const LicenseService = function () {
};
const license_service = new LicenseService();
util.inherits(LicenseService, EventEmitter);


payment_service.on('StateChange', function (data) {
    const transactionUuid = data.invoice.referenceId;
    if (data.payment && data.payment.paydate) {
        dbTrans.GetTransactionByID(config.USER, transactionUuid, function (err, transaction) {
            if (!err && !transaction.licenseorderuuid) {

                dbPayment.GetPaymentInvoiceForOfferRequest(config.USER, transaction.offerrequestuuid, function(err, paymentAndInvoice) {

                    licenseCentral.createAndActivateLicense(cmSerial, transaction.buyer, itemId, quantity, function(err, success) {

                    });
                    //TODO: create and activate license licenseCentral.createAndActivateLicense()
                    dbLicence.CreateLicenseOrder(null, transaction.offeruuid, config.USER, function (err, data) {
                        if (!err) {
                            license_service.emit('updateAvailable', data.offeruuid, 'TW552HSM');
                        }
                    });


                });

            }
        });
    }
});


module.exports = license_service;