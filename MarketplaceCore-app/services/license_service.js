const EventEmitter = require('events').EventEmitter;
const util = require('util');
const payment_service = require('./payment_service');
const license_service = new LicenseService();
util.inherits(LicenseService, EventEmitter);


payment_service.on('StateChange', function(state){
    if(state.state == 'pending' || state.state == 'building'){
        offerID = state.referenceId;

        queries.GetOfferByID(req.query['userUUID'], offerId, function (err, data) {
            if (!err) {
                var hsmId = data.hsmId;
                license_service.emit('updateAvailable',offerId, hsmId);
            }
        });
    }
});