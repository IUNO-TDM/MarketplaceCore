const EventEmitter = require('events').EventEmitter;
const util = require('util');
const payment_service = require('./payment_service');
var queries = require('../connectors/pg-queries');
const config = require('../global/constants');

var LicenseService = function () {
};
const license_service = new LicenseService();
util.inherits(LicenseService, EventEmitter);


payment_service.on('StateChange', function (data) {
    var transactionUuid = data.invoice.referenceId;
    if (data.payment && data.payment.paydate) {
        queries.GetTransactionByID(config.CONFIG.USER_UUID, transactionUuid, function (err, transaction) {
            if (!err && !transaction.licenseorderuuid) {
                queries.CreateLicenseOrder(null, transaction.offeruuid, config.CONFIG.USER_UUID, function (err, data) {
                    if (!err) {
                        license_service.emit('updateAvailable', data.offeruuid, 'TW552HSM');
                    }
                });
            }
        });
    }
});


module.exports = license_service;