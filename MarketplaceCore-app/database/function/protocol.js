const logger = require('../../global/logger');
const db = require('../db_connection');

let self = {};

self.CreateProtocols = function (protocol, clientid, createdby, roles, callback) {
    db.func('CreateProtocols', [protocol, clientid, createdby, roles])
        .then(function (data) {
            if (data && data.length) {
                data = data[0];
            }

            logger.debug('CreateProtocols result: ' + JSON.stringify(data));
            callback(null, data);
        })
        .catch(function (error) {
            logger.crit(error);
            callback(error);
        });
};

self.GetProtocols = function (eventType, from, to, user, roles, callback) {
    db.func('GetProtocols', [eventType, from, to, user, roles])
        .then(function (data) {
            logger.debug('GetProtocols result: ' + JSON.stringify(data));
            callback(null, data);
        })
        .catch(function (error) {
            logger.crit(error);
            callback(error);
        });
};

module.exports = self;