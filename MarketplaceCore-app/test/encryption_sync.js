const CryptoJS = require('crypto-js');
const fs = require('fs');
const path = require('path');
const crypto = require("crypto");
const logger = require('../global/logger');
const CONFIG = {
    PUBLIC_KEY_FILE_FOR_ENCRYPTION: path.resolve('test/ultimaker.pub')
};

const self = {};

function convertWordArrayToUint8Array(wordArray) {
    let len = wordArray.words.length,
        u8_array = new Uint8Array(len << 2),
        offset = 0, word, i
    ;
    for (i = 0; i < len; i++) {
        word = wordArray.words[i];
        u8_array[offset++] = word >> 24;
        u8_array[offset++] = (word >> 16) & 0xff;
        u8_array[offset++] = (word >> 8) & 0xff;
        u8_array[offset++] = word & 0xff;
    }
    return u8_array;
}


self.encryptGCode = function (gcode, keys) {

    // split header from g-code
    const splitAt = ';END_OF_HEADER\n';
    gcode = gcode.split(splitAt);

    if (gcode.length !== 2) {
        logger.crit('[encryption_service] cannot encrypt malformed g-code string');

        throw  new Error('could not separate header from g-code content');
    }

    const header = gcode[0] + splitAt;
    const content = gcode[1];

    // write header into buffer
    const headerBuffer = new Buffer(header);

    // convert header length into little endian buffer
    const headerLengthBuffer = Buffer.alloc(4);
    headerLengthBuffer.writeUInt32LE(headerBuffer.length, 0);

    // encrypt the g-code content only
    const encryptedData = self.encryptData(content, keys);

    // bundle header length, header and encrypted g-code content together
    encryptedData['fileBundle'] = Buffer.concat([
        headerLengthBuffer,
        headerBuffer,
        encryptedData.encryptedFileBuffer
    ]);

    return encryptedData;
};

self.encryptData = function (data, keys) {
    try {
        // generate random key with 256 bit length
        const aesKey = keys['aesKey'];
        // generate random IV with 128 bit length
        const iv = keys['iv'];

        // encrypt data using AES with generated key, vi and CBC mode
        const encryptedData = CryptoJS.AES.encrypt(data, aesKey, {
            iv: iv,
            mode: CryptoJS.mode.CBC
        });

        // convert aes key into binary data
        const passwordBuffer = new Buffer(convertWordArrayToUint8Array(aesKey));

        // read public key from file
        const publicKeyPath = path.resolve(CONFIG.PUBLIC_KEY_FILE_FOR_ENCRYPTION);
        const publicKey = fs.readFileSync(publicKeyPath, 'utf8');

        // encrypt aes key using rsa with the public key
        const encryptedKey = crypto.publicEncrypt({
            key: publicKey,
            padding: crypto.constants.RSA_PKCS1_PADDING
        }, passwordBuffer);


        // bundle the encrypted key and iv
        const keyBundle = Buffer.concat([
            encryptedKey,
            new Buffer(convertWordArrayToUint8Array(iv))]);

        // read ciphertext word array into file buffer
        const encryptedFileBuffer = new Buffer(convertWordArrayToUint8Array(encryptedData.ciphertext));

        return {
            keyBundleB64: keyBundle.toString('base64'),
            encryptedFileBuffer: encryptedFileBuffer
        };
    }
    catch (err) {
        logger.crit('[encryption_service] error whiling trying to encrypt file');
        logger.crit(err);

        throw  err;
    }
};

self.createDecryptionBundle = function (encryptedKeysB64, productCode, fileBundle) {

    // convert product code to little endian buffer
    const productCodeBuffer = Buffer.alloc(4);
    productCodeBuffer.writeUInt32LE(productCode, 0);

    // decode base64 string into buffer
    const encryptedKeyBuffer = Buffer.from(encryptedKeysB64, 'base64');


    // bundle LE, encrypted keys and encrypted file together
    return Buffer.concat([
        productCodeBuffer,
        encryptedKeyBuffer,
        fileBundle
    ]);
};

module.exports = self;