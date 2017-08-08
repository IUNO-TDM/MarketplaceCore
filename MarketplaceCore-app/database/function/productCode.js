const logger = require('../../global/logger');
const db = require('../db_connection');
const USER = require('../../config/config_loader').USER;
let self = {};

self.GetNewProductCode = function (callback) {
    db.func('GetNewProductCode', [USER.uuid, USER.roles])
        .then(function (data) {
            if (data && data.length) {
                data = data[0];
            }

            logger.debug('[productCode] GetNewProductCode: ' + JSON.stringify(data));
            callback(null, data);
        })
        .catch(function (error) {
            logger.crit(error);
            callback(error);
        });
};


module.exports = self;

