const CryptoJS = require('crypto-js');
const fs = require('fs');
const path = require('path');
const crypto = require("crypto");
const logger = require('../global/logger');
const CONFIG = require('../config/config_loader');
const Promise = require('promise');
const Readable = require('stream').Readable;
const CombinedStream = require('combined-stream');
CONFIG.PUBLIC_KEY_FILE_FOR_ENCRYPTION = path.resolve('test/ultimaker.pub');


/**
 * Encryption class to hold streaming algorithms for encrypt gcode into iunom3
 */
const self = function () {
    let _keyBundleB64 = undefined;
    let _aesKey = undefined;
    let _iv = undefined;
    let _header = undefined;
    let _gCodePath = undefined;

    /**
     * Initialing the encryption class by parsing the header and creating the key bundle
     * @param gCodePath
     * @return {Promise<void>}
     */
    this.init = async function (gCodePath, _keys) {
        logger.debug('[iuno_m3_encryption] initializing object');
        // parse only header into memory
        _header = await parseHeader(gCodePath);
        _gCodePath = gCodePath;
        const keys = createKeyBundleB64(_keys);
        _keyBundleB64 = keys.keyBundleB64;
        _aesKey = keys.aesKey;
        _iv = keys.iv;
    };

    /**
     * Gets the base64 encoded key bundle. Only accessible after init was called.
     * @return {undefined}
     */
    this.getKeyBundleB64 = function () {
        if (!_keyBundleB64) {
            throw new Error('Class was not initialized: Please call init() first and wait until the async function returned');
        }
        return _keyBundleB64;
    };

    this.getEncryptionStream = function () {
        if (!_keyBundleB64) {
            throw new Error('Class was not initialized: Please call init() first and wait until the async function returned');
        }

        logger.debug('[iuno_m3_encryption] generate encryption stream for object');
        // create content stream starting after header
        const contentStream = fs.createReadStream(
            path.resolve(_gCodePath),
            {
                flags: 'r',
                encoding: 'utf-8',
                start: _header.length
            });

        // write header into buffer
        const headerBuffer = new Buffer(_header);

        // convert header length into little endian buffer
        const headerLengthBuffer = Buffer.alloc(4);
        headerLengthBuffer.writeUInt32LE(headerBuffer.length, 0);

        // create a cipher stream for aes 256 cbc
        const cipher = crypto.createCipheriv('aes-256-cbc', _aesKey, _iv);

        // create readable header stream including header length and header buffer
        const headerStream = new Readable({
            objectMode: false,
            read(size) {
                headerStream.push(headerLengthBuffer);
                headerStream.push(headerBuffer);
                headerStream.push(null);
            }
        });

        // combine header and cipher stream into a single stream
        const combinedStream = CombinedStream.create();
        combinedStream.append(headerStream);
        combinedStream.append(contentStream.pipe(cipher));

        return combinedStream;
    }
};

function createKeyBundleB64(keys) {
    logger.debug('[iuno_m3_encryption] creating base64 encoded key bundle for object');

    // generate random key with 256 bit length
    const aesKey = keys['aesKey'];
    // generate random IV with 128 bit length
    const iv = keys['iv'];

    // convert aes key and iv into binary data
    const passwordBuffer = new Buffer(convertWordArrayToUint8Array(aesKey));
    const ivBuffer = new Buffer(convertWordArrayToUint8Array(iv));
    //

    // read public key from file
    const publicKeyPath = path.resolve(CONFIG.PUBLIC_KEY_FILE_FOR_ENCRYPTION);
    const publicKey = fs.readFileSync(publicKeyPath, 'utf8');

    // encrypt aes key using rsa with the public key
    const encryptedKey = crypto.publicEncrypt({
        key: publicKey,
        padding: crypto.constants.RSA_PKCS1_PADDING
    }, passwordBuffer);


    // bundle the encrypted key and iv
    const keyBundle = Buffer.concat(
        [
            encryptedKey,
            ivBuffer
        ]);

    return {
        aesKey: passwordBuffer,
        iv: ivBuffer,
        keyBundleB64: keyBundle.toString('base64')
    };
}


async function parseHeader(gCodePath) {
    logger.debug('[iuno_m3_encryption] parsing header');
    const separator = ';END_OF_HEADER\n';

    return new Promise(function (fulfill, reject) {
        try {
            // create a read stream for the file
            const stream = fs.createReadStream(
                path.resolve(gCodePath),
                {
                    flags: 'r',
                    encoding: 'utf-8'
                });

            let header = '';

            function listener(chunk) {
                // pause stream on every chunk
                stream.pause();

                // split chunk in lines
                const lines = chunk.split('\n');

                // search for end of header
                for (let i = 0; i < lines.length; i++) {
                    const line = lines[i] + '\n';
                    header += line;
                    if (line === separator) {
                        stream.removeListener('data', listener);
                        fulfill(header);
                    }
                    stream.resume();
                }
            }

            stream.addListener('data', listener);
        } catch (err) {
            logger.error(err);
            reject(err);
        }

    });
}

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


module.exports = self;