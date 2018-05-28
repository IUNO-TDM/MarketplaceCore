/**
 * Created by goergch on 07.05.2018.
 */

const EventEmitter = require('events').EventEmitter;
const util = require('util');
const dbProtocols = require('../database/function/protocol');

const ProtocolService = function () {
};
const protocol_service = new ProtocolService();
util.inherits(ProtocolService, EventEmitter);


protocol_service.newProtocol = function (protocol, clientId, userid, roles, callback) {
    protocol_service.emit(protocol.eventType,protocol, clientId);
    dbProtocols.CreateProtocols(protocol, clientId, userid,roles, callback);
};

module.exports = protocol_service;