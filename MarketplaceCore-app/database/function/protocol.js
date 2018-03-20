/**
 * Created by beuttlerma on 31.05.17.
 */
const logger = require('../../global/logger');
const db = require('../db_connection');

let self = {};

self.CreateProtocols = function (protocol, clientid, roles, callback) {
    db.func('CreateProtocols', [protocol, clientid, roles])
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

module.exports = self;