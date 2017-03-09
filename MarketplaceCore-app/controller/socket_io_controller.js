/**
 * Created by beuttlerma on 08.02.17.
 */

var logger = require('../global/logger');
const license_service = require('../services/license_service');
function onIOLicenseConnect(socket) {
    logger.debug('Client for Licenses connected.' + socket.id);

    socket.on('room', function(hsmid) {
        logger.debug('Client joining room: ' + hsmid);

        socket.join(hsmid);
    });
    socket.on('leave', function(hsmid) {
        logger.debug('Client leaves room: ' + hsmid);

        socket.leave(hsmid);
    });

    socket.on('disconnect', function () {
        logger.debug('Client for Licenses disconnected: ' + socket.id);
    });
}

module.exports = function (io) {

    var namespace = io.of('/licenses');
    namespace.on('connection', onIOLicenseConnect);
    registerLicenseEvents();

};

function registerLicenseEvents(){
    license_service.on('updateAvailable', function(offerId,hsmId){
        socket.to(hsmId).emit('updateAvailable',{hsmId: hsmId, offerId: offerId});
    })
}