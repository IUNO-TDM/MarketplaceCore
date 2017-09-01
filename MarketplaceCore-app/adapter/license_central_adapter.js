const logger = require('../global/logger');
const CONFIG = require('../config/config_loader');
const request = require('request');

const fs = require('fs');
const path = require('path');

const p12File = path.resolve(__dirname, CONFIG.LICENSE_CENTRAL.CERT.P12_FILE_PATH);

const self = {};

function buildOptionsForRequest(method, protocol, host, port, path, qs) {

    const options = {
        method: method,
        url: protocol + '://' + host + '/' + path,
        qs: qs,
        json: true,
        headers: {
            'content-type': 'application/json',
            'accept': 'application/json'
        }
    };

    // if (CONFIG.LICENSE_CENTRAL.BASIC_AUTH.USER && CONFIG.LICENSE_CENTRAL.BASIC_AUTH.PASSWORD) {
    //     options.headers['Authorization'] =
    //         'Basic ' + new Buffer(CONFIG.LICENSE_CENTRAL.BASIC_AUTH.USER + ':' + CONFIG.LICENSE_CENTRAL.BASIC_AUTH.PASSWORD).toString('base64')
    // }

    try {
        options.pfx = fs.readFileSync(p12File);
        options.passphrase = CONFIG.LICENSE_CENTRAL.CERT.PASS_PHRASE;
        //     options.secureProtocol = 'SSLv3_method'
        // options.securityOptions = 'SSL_OP_NO_SSLv3';
    }
    catch (err) {
        logger.warn('[license_central_adapter] Error loading client certificates');
        logger.info(err);
    }

    return options;
}

self.createItem = function (itemId, itemName, productCode, callback) {

    if (typeof(callback) !== 'function') {
        callback = function () {
            logger.info('[license_central_adapter] Callback not registered');
        }
    }

    const options = buildOptionsForRequest(
        'POST',
        CONFIG.HOST_SETTINGS.LICENSE_CENTRAL.PROTOCOL,
        CONFIG.HOST_SETTINGS.LICENSE_CENTRAL.HOST,
        CONFIG.HOST_SETTINGS.LICENSE_CENTRAL.PORT,
        'doCreateItem.php',
        {}
    );

    options.body = {
        itemid: itemId,
        itemname: itemName,
        firmcode: CONFIG.LICENSE_CENTRAL.FIRM_CODE,
        productcode: productCode
    };

    request(options, function (e, r, message) {
        logger.log(message);
        const err = logger.logRequestAndResponse(e, options, r, message);

        if (err) {
            return callback(err);
        }

        callback(err, true)
    });

};

self.encryptData = function (productCode, data, callback) {
    if (typeof(callback) !== 'function') {
        callback = function () {
            logger.info('[license_central_adapter] Callback not registered');
        }
    }

    const options = buildOptionsForRequest(
        'POST',
        CONFIG.HOST_SETTINGS.LICENSE_CENTRAL.PROTOCOL,
        CONFIG.HOST_SETTINGS.LICENSE_CENTRAL.HOST,
        CONFIG.HOST_SETTINGS.LICENSE_CENTRAL.PORT,
        'doEncryptData.php',
        {}
    );

    options.body = {
        firmcode: CONFIG.LICENSE_CENTRAL.FIRM_CODE,
        productcode: productCode,
        buffer: data
    };

    request(options, function (e, r, message) {
        const err = logger.logRequestAndResponse(e, options, r, message);

        if (err) {
            return callback(err);
        }

        callback(err, message.content);
    });
};

self.createAndActivateLicense = function (hsmId, customerId, itemId, quantity, callback) {
    if (typeof(callback) !== 'function') {
        callback = function () {
            logger.info('[license_central_adapter] Callback not registered');
        }
    }

    const options = buildOptionsForRequest(
        'POST',
        CONFIG.HOST_SETTINGS.LICENSE_CENTRAL.PROTOCOL,
        CONFIG.HOST_SETTINGS.LICENSE_CENTRAL.HOST,
        CONFIG.HOST_SETTINGS.LICENSE_CENTRAL.PORT,
        'doCreateOrder.php',
        {}
    );
    options.body = {
        cmserial: hsmId,
        // customerid: customerId,
        itemid: itemId,
        quantity: quantity
    };

    request(options, function (e, r, message) {
        const err = logger.logRequestAndResponse(e, options, r, message);

        if (err) {
            return callback(err);
        }

        callback(err, true)
    });
};

self.doLicenseUpdate = function (hsmId, context, callback) {
    if (typeof(callback) !== 'function') {
        callback = function () {
            logger.info('[license_central_adapter] Callback not registered');
        }
    }

    const options = buildOptionsForRequest(
        'POST',
        CONFIG.HOST_SETTINGS.LICENSE_CENTRAL.PROTOCOL,
        CONFIG.HOST_SETTINGS.LICENSE_CENTRAL.HOST,
        CONFIG.HOST_SETTINGS.LICENSE_CENTRAL.PORT,
        'doLicenseUpdate.php',
        {}
    );

    options.body = {
        cmserial: hsmId,
        context: context,
        firmcode: CONFIG.LICENSE_CENTRAL.FIRM_CODE,
        cmactid: CONFIG.LICENSE_CENTRAL.CMACTID,
        lcaction: CONFIG.LICENSE_CENTRAL.LCACTION
    };

    request(options, function (e, r, message) {
        let isOutOfDate = false;

        const err = logger.logRequestAndResponse(e, options, r, message);

        if (err) {
            return callback(err);
        }

        // 205 indicates that the provided context is out of date.
        // The context within the lcc is different
        // After applying the sent update, the client needs to request a update again, using a new context.
        if (r.statusCode === 205) {
            isOutOfDate = true;
        }

        callback(err, message.content, isOutOfDate);
    });
};

self.createAndEncrypt = function (itemId, itemName, productCode, data, callback) {
    if (typeof(callback) !== 'function') {
        callback = function () {
            logger.info('[license_central_adapter] Callback not registered');
        }
    }

    self.createItem(itemId, itemName, productCode, function (err, success) {

        if (err) {
            logger.crit('[license_central_adapter] Could not create item');
            return callback(err);
        }

        if (!success) {
            return callback(new Error('[license_central_adapter] Something broke without error message'));
        }

        self.encryptData(productCode, data, function (err, encryptedData) {
            if (err) {
                logger.crit('[license_central_adapter] Could not encrypt data');
                return callback(err);
            }

            return callback(null, encryptedData);
        })
    })
};

self.doConfirmUpdate = function (context, callback) {
    if (typeof(callback) !== 'function') {
        callback = function () {
            logger.info('[license_central_adapter] Callback not registered');
        }
    }

    const options = buildOptionsForRequest(
        'POST',
        CONFIG.HOST_SETTINGS.LICENSE_CENTRAL.PROTOCOL,
        CONFIG.HOST_SETTINGS.LICENSE_CENTRAL.HOST,
        CONFIG.HOST_SETTINGS.LICENSE_CENTRAL.PORT,
        'doConfirmUpdate.php',
        {}
    );

    options.body = {
        context: context
    };

    request(options, function (e, r, message) {
        const err = logger.logRequestAndResponse(e, options, r, message);

        if (err) {
            return callback(err);
        }

        callback(null);
    });
};

module.exports = self;