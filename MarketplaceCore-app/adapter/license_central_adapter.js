const logger = require('../global/logger');
const CONFIG = require('../config/config_loader');
const request = require('request');

const fs = require('fs');
const path = require('path');
const certFile = path.resolve(__dirname, CONFIG.LICENSE_CENTRAL.CERT.CERT_FILE_PATH);
const keyFile = path.resolve(__dirname, CONFIG.LICENSE_CENTRAL.CERT.CERT_FILE_PATH);

const self = {};

function buildOptionsForRequest(method, protocol, host, port, path, qs) {

    return {
        method: method,
        url: protocol + '://' + host + ':' + port + path,
        qs: qs,
        json: true,
        headers: {
            'Authorization': 'Basic ' + new Buffer(CONFIG.LICENSE_CENTRAL.BASIC_AUTH.USER + ':' + CONFIG.LICENSE_CENTRAL.BASIC_AUTH.PASSWORD).toString('base64')
        },
        agentOptions: {
            cert: fs.readFileSync(certFile),
            key: fs.readFileSync(keyFile),
            // Or use `pfx` property replacing `cert` and `key` when using private key, certificate and CA certs in PFX or PKCS12 format:
            // pfx: fs.readFileSync(pfxFilePath),
            passphrase: CONFIG.LICENSE_CENTRAL.CERT.PASS_PHRASE
            // securityOptions: 'SSL_OP_NO_SSLv3'
        }
    }
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

self.encryptData = function (firmCode, productCode, data, callback) {
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

self.doLicenseUpdate = function (cmSerial, context, cmactid, location, callback) {
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
        cmactid: cmactid,
        location: location
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