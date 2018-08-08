/**
 * Created by beuttlerma on 08.02.17.
 */

const logger = require('../global/logger');
const license_service = require('../services/license_service');
const authentication = require('../services/authentication_service');

function onIOLicenseConnect(socket) {
    logger.debug('Client for Licenses connected.' + socket.id);

    socket.on('room', function (hsmid) {
        logger.debug('Client joining room: ' + hsmid);

        socket.join(hsmid);
    });
    socket.on('leave', function (hsmid) {
        logger.debug('Client leaves room: ' + hsmid);

        socket.leave(hsmid);
    });

    socket.on('disconnect', function () {
        logger.debug('Client for Licenses disconnected: ' + socket.id);
    });
}

module.exports = function (io) {
    const namespace = io.of('/licenses');

    // Enable bearer authentication for socket.io
    namespace.use(authentication.ws_oAuth);
    namespace.on('connection', onIOLicenseConnect);

    registerLicenseEvents(namespace);

};

function registerLicenseEvents(namespace) {
    license_service.on('updateAvailable', function (offerId, hsmId) {
        logger.debug(`[socket_io_controller] emitting update available for hsmid: ${hsmId} and ofer ${offerId}`);
        namespace.to(hsmId).emit('updateAvailable', {hsmId: hsmId, offerId: offerId});
    })
}