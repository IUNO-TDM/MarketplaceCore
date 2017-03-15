const EventEmitter = require('events').EventEmitter;
const util = require('util');
const payment_service = require('./payment_service');
var queries = require('../connectors/pg-queries');
const config = require('../global/constants');

var LicenseService = function () {};
const license_service = new LicenseService();
util.inherits(LicenseService, EventEmitter);


payment_service.on('StateChange', function(state){
    if(state.state == 'pending' || state.state == 'building'){
        var transactionUuid = state.referenceId;

        queries.GetOfferForTransaction(config.CONFIG.USER_UUID, transactionUuid, function (err, data) {
            if (!err) {
                license_service.emit('updateAvailable',data[0].offeruuid, 'TW552HSM');
            }
        });
    }
});


module.exports = license_service;