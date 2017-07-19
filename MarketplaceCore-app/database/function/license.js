/**
 * Created by beuttlerma on 31.05.17.
 */
var logger = require('../../global/logger');
var db = require('../db_connection');

var self = {};


self.CreateLicenseOrder = function(ticketId, offerUUID, userUUID, callback) {
    db.func('CreateLicenseOrder', [ticketId, offerUUID, userUUID])
        .then(function (data) {
            if (data && data.length) {
                data = data[0];
            }

            logger.debug('CreateLicenseOrder result: ' + JSON.stringify(data));
            callback(null, data);
        })
        .catch(function (error) {
            logger.crit(error);
            callback(error);
        });
};

self.GetLicenseFeeByTechnologyData = function(userUUID, technologyDataUUID, roleName, callback) {
    db.func('GetLicenseFeeByTechnologyData', [technologyDataUUID, userUUID, roleName])
        .then(function (data) {
            if (data && data.length) {
                data = data[0];
            }
            callback(null, data.licensefee)
        })
        .catch(function (error) {
            logger.crit(error);
            callback(error);
        });
};

module.exports = self;