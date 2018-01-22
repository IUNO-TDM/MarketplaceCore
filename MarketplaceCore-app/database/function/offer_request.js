/**
 * Created by beuttlerma on 31.05.17.
 */
var logger = require('../../global/logger');
var db = require('../db_connection');

var self = {};


self.CreateOfferRequest = function (userUUID, clientUUID, roles, requestData, callback) {
    logger.debug('User UUID: ' + userUUID);
    db.func('CreateOfferRequest',
        [requestData,
            requestData.hsmId,
            userUUID,
            clientUUID,
            roles
        ])
        .then(function (data) {
            logger.debug(data);

            if (data && data.length) {
                data = data[0];
            }
            else {
                data = null;
            }

            callback(null, data);
        })
        .catch(function (error) {
            logger.crit(error);
            callback(error);
        });
};

self.GetOfferRequestById = function (offerUUID, user, callback) {
    db.func('GetOfferRequestById',
        [
            offerUUID,
            user.uuid,
            user.roles
        ])
        .then(function (data) {
            logger.debug(data);

            if (data && data.length && data[0]['result']) {
                data = data[0]['result'];
            }
            else {
                data = null;
            }

            callback(null, data);
        })
        .catch(function (error) {
            logger.crit(error);
            callback(error);
        });
};

module.exports = self;