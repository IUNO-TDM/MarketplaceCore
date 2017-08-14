const logger = require('../global/logger');
const CONFIG = require('../config/config_loader');
const request = require('request');

const fs = require('fs');
const path = require('path');

const certFile = path.resolve(__dirname, CONFIG.LICENSE_CENTRAL.CERT.CERT_FILE_PATH);
const keyFile = path.resolve(__dirname, CONFIG.LICENSE_CENTRAL.CERT.CERT_FILE_PATH);
const p12File = path.resolve(__dirname, CONFIG.LICENSE_CENTRAL.CERT.P12_FILE_PATH);

const self = {};

function buildOptionsForRequest(method, protocol, host, port, path, qs) {

    const options = {
        method: method,
        url: protocol + '://' + host + '/' + path,
        qs: qs,
        json: true,
        headers: {},
        agentOptions: {}
    };

    if (CONFIG.LICENSE_CENTRAL.BASIC_AUTH.USER && CONFIG.LICENSE_CENTRAL.BASIC_AUTH.PASSWORD) {
        options.headers['Authorization'] =
            'Basic ' + new Buffer(CONFIG.LICENSE_CENTRAL.BASIC_AUTH.USER + ':' + CONFIG.LICENSE_CENTRAL.BASIC_AUTH.PASSWORD).toString('base64')
    }

    try {
        // options.agentOptions['cert'] = fs.readFileSync(certFile);
        // options.agentOptions['key'] = fs.readFileSync(keyFile);
        // Or use `pfx` property replacing `cert` and `key` when using private key, certificate and CA certs in PFX or PKCS12 format:
        // pfx: fs.readFileSync(pfxFilePath),
        pfx: fs.readFileSync(p12File);
        options.agentOptions['passphrase'] = CONFIG.LICENSE_CENTRAL.CERT.PASS_PHRASE
        // securityOptions: 'SSL_OP_NO_SSLv3'
    }
    catch (err) {
        logger.warn('[license_central_adapter] Error loading client certificates');
        logger.crit(err);
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

        let encryptedData = null;

        if (message['Result']) {
            encryptedData = message['Result'].content;
        }

        callback(err, encryptedData)
    });
};

self.createAndActivateLicense = function (cmSerial, customerId, itemId, quantity, callback) {
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
        'doCreateOrderIUNO.php',
        {}
    );

    options.body = {
        cmserial: cmSerial,
        customerid: customerId,
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

self.doLicenseUpdate = function (cmSerial, context, callback) {
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
        cmserial: cmSerial,
        context: context,
        firmcode: CONFIG.LICENSE_CENTRAL.FIRM_CODE,
        cmactid: CONFIG.LICENSE_CENTRAL.CMACTID,
        lcaction: CONFIG.LICENSE_CENTRAL.LCACTION
    };

    request(options, function (e, r, message) {
        const err = logger.logRequestAndResponse(e, options, r, message);

        if (err) {
            return callback(err);
        }

        let licenseUpdate = null;

        if (message['Result']) {
            licenseUpdate = message['Result'].content;
        }

        callback(err, licenseUpdate)
    });
};

self.createAndEncrypt = function (itemId, itemName, productCode, data, callback) {
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

module.exports = self;


self.createItem('Test1234', 'Test1234', 991234, function(err, success) {
    logger.log(err);
    logger.log(success);
});