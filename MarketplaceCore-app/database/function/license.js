/**
 * Created by beuttlerma on 31.05.17.
 */
const logger = require('../../global/logger');
const db = require('../db_connection');

let self = {};


self.CreateLicenseOrder = function (offerUUID, user, callback) {
    db.func('CreateLicenseOrder', [offerUUID, user.uuid, user.roles])
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

self.GetLicenseFeeByTechnologyData = function (userUUID, technologyDataUUID, roles, callback) {
    db.func('GetLicenseFeeByTechnologyData', [technologyDataUUID, userUUID, roles])
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

self.GetActivatedLicenseCountForUser = function (technologyUUID, userUUID, grant, callback) {
    db.func('GetActivatedLicensesCountForUser', [technologyUUID, userUUID, grant['id'], grant['roles']])
        .then(function (data) {
            if (data && data.length) {
                data = data[0];
            }
            callback(null, data['getactivatedlicensescountforuser'] ? data['getactivatedlicensescountforuser'] : 0);
        })
        .catch(function (error) {
            logger.crit(error);
            callback(error);
        });
};

module.exports = self;