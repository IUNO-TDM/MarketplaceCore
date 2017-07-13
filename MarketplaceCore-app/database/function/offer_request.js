/**
 * Created by beuttlerma on 31.05.17.
 */
var logger = require('../../global/logger');
var db = require('../db_connection');

var self = {};


self.CreateOfferRequest = function (userUUID, requestData, callback) {
    logger.debug('User UUID: ' +  userUUID);
    db.func('CreateOfferRequest',
        [   requestData,
            requestData.hsmId,
            userUUID,
            userUUID //TODO: what is the buyer uuid?
        ])
        .then(function (data) {
            logger.debug(data);
            callback(null, data);
        })
        .catch(function (error) {
            logger.crit(error);
            callback(error);
        });
};

module.exports = self;