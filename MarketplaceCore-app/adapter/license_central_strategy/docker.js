
const logger = require('../../global/logger');

let self = require('./default');

logger.warn('[license_central_adapter] RUNNING DOCKER (SIMULATION) MODE. LCC calls will be skipped!');

self.createItem = function (itemId, itemName, productCode, callback) {
    callback(null, true);
};

self.encryptData = function (productCode, data, callback) {
    callback(null, data);
};

self.createAndActivateLicense = function (hsmId, customerId, itemId, quantity, callback) {
    callback(null, true);
};

self.doLicenseUpdate = function (hsmId, context, callback) {
    callback(null, new Buffer('SIMULATION').toString('base64'));
};

self.doConfirmUpdate = function (context, callback) {
    callback(null);
};

module.exports = self;