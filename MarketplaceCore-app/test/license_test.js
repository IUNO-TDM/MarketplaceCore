var licenseCentral = require('../adapter/license_central_adapter');


const cmSerial = '3-4019156';
const customerId = 1234;
const productCode = 10;
const itemId = 'pc' + productCode;
const itemName = 'Test ' + getRandomInt(1,999999999999999);
const quantity = 1;

function getRandomInt(min, max) {
    return Math.floor(Math.random() * (max - min + 1)) + min;
}

licenseCentral.createItem(itemId, itemName, productCode, function(err, success) {
    if (err) {
        console.error(err);
    }
    console.log('Create Item: ' + success);

    licenseCentral.createAndActivateLicense(cmSerial, customerId, itemId, quantity, function (err, success) {
        if (err) {
            console.error(err);
        }
        console.log('ActivateLicense: ' + success);
    });
});
//
// licenseCentral.doConfirmUpdate('1234', function (err) {
//    console.log('Error: ' + err);
// });

// There are no activatable licenses assigned for CmContainer with serial  ID 3-4019155
// Cannot create update from an old CmActLicense context
//
//
// const CONFIG = require('../config/config_loader');
// const fs = require('fs');
// const path = require('path');
// const p12File = path.resolve(__dirname, CONFIG.LICENSE_CENTRAL.CERT.P12_FILE_PATH);
// const request = require('request');
//
// const options = {
//     method: 'POST',
//     url: 'https://lc-admin.codemeter.com/26959-02/marketplaceapi/doCreateItem.php',
//     qs: {},
//     json: true,
//     headers: {
//         'content-type': 'application/json',
//         'accept': 'application/json'
//     },
//     agentOptions: {}
// };
//
// try {
//     // options.agentOptions['cert'] = fs.readFileSync(certFile);
//     // options.agentOptions['key'] = fs.readFileSync(keyFile);
//     // Or use `pfx` property replacing `cert` and `key` when using private key, certificate and CA certs in PFX or PKCS12 format:
//     // pfx: fs.readFileSync(pfxFilePath),
//
//     options.pfx = fs.readFileSync(p12File);
//     options.passphrase = CONFIG.LICENSE_CENTRAL.CERT.PASS_PHRASE;
//     options.securityOptions = 'SSL_OP_NO_SSLv3';
//     // options.secureProtocol = 'TLSv1_2_method'
// }
// catch (err) {
//     logger.warn('[license_central_adapter] Error loading client certificates');
//     logger.info(err);
// }
//
//
// request(options, function (err, r, data) {
//     console.log(err);
//     console.log(r);
//     console.log(data);
// });

// const https = require('https');
//
// const req = https.request({
//     hostname: 'lc-admin.codemeter.com',
//     port: 443,
//     path: '/26959-02/marketplaceapi/doCreateItem.php',
//     method: 'GET',
//     secureProtocol:'TLSv1_2_method',
//     pfx: fs.readFileSync(p12File),
//     passphrase: CONFIG.LICENSE_CENTRAL.CERT.PASS_PHRASE
//
// }, function (res) {
//     res.on('data', (d) => {
//         console.log(d);
//     });
// });
//
// req.on('error', (e) => {
//     console.error(e);
// });
//
// req.end();