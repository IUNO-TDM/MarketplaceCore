/**
 * Created by beuttlerma on 08.02.17.
 */

const logger = require('../global/logger');
const license_service = require('../services/license_service');
const protocol_service = require('../services/protocol_service');
const payment_service = require('../services/payment_service');
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

function onIOVisConnect(socket) {
    logger.debug('Client for Visualization Socket IO connected.' + socket.id);


    socket.on('disconnect', function () {
        logger.debug('Client for Visualization Socket IO disconnected: ' + socket.id);
    });
}

module.exports = function (io) {
    const namespace = io.of('/licenses');
    const visNamespace = io.of('/visualization');

    // Enable bearer authentication for socket.io
    namespace.use(authentication.ws_oAuth);
    namespace.on('connection', onIOLicenseConnect);

    visNamespace.use(authentication.ws_oAuth);
    visNamespace.on('connection', onIOVisConnect);

    registerLicenseEvents(namespace);
    registerVisualizationEvents(visNamespace);

};

function registerLicenseEvents(namespace) {
    license_service.on('updateAvailable', function (offerId, hsmId, clientId) {
        namespace.to(hsmId).emit('updateAvailable', {hsmId: hsmId, offerId: offerId});
    })
}

function registerVisualizationEvents(namespace) {
    protocol_service.on('connection', function (protocol, clientId) {
        namespace.emit('machineconnection',{clientId: clientId, connected: protocol.payload.connected})
    });
    protocol_service.on('offerrequest', function (protocol, clientId) {
        namespace.emit('offerrequest',{clientId: clientId, items: protocol.payload.requestData.items})
    });

    protocol_service.on('payment', function (protocol, clientId) {
        namespace.emit('payment',{clientId: clientId, payment: protocol.payload.payment})
    });
    protocol_service.on('payingtransactions', function (protocol, clientId) {
        namespace.emit('payingtransactions',{clientId: clientId, transactions: protocol.payload.transactions})
    });
    protocol_service.on('productionState', function (protocol, clientId) {
        namespace.emit('productionState',{clientId: clientId, state: protocol.payload})
    });
    license_service.on('updateAvailable', function (offerId, hsmId, clientId) {
        namespace.emit('licenseAvailable',{clientId: clientId, hsmId: hsmId})
    });
    protocol_service.on('licenseupdate', function (protocol, clientId) {
        namespace.emit('licenseupdate',{clientId: clientId, hsmId: protocol.payload.hsmId})
    });
    protocol_service.on('licenseupdateconfirm', function (protocol, clientId) {
        namespace.emit('licenseupdateconfirm',{clientId: clientId, hsmId: protocol.payload.hsmId})
    });
    protocol_service.on('newtechnologydata', function (protocol, clientId) {
        namespace.emit('newtechnologydata',{clientId: clientId, technologydataid: protocol.payload.technologydataid})
    });
}
