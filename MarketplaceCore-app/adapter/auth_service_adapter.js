/**
 * Created by beuttlerma on 02.06.17.
 */


var logger = require('../global/logger');
const CONFIG = require('../config/config_loader');
var request = require('request');

var self = {};

function buildOptionsForRequest(method, protocol, host, port, path, qs) {

    return {
        method: method,
        url: protocol + '://' + host + ':' + port + path,
        qs: qs,
        json: true,
        headers: {
            'Authorization': 'Basic ' + new Buffer(CONFIG.OAUTH_CREDENTIALS.CLIENT_ID + ':' + CONFIG.OAUTH_CREDENTIALS.CLIENT_SECRET).toString('base64')
        }
    }
}

self.validateToken = function (accessToken, callback) {


    if (typeof(callback) !== 'function') {

        callback = function () {
            logger.info('Callback not registered');
        }
    }

    const options = buildOptionsForRequest(
        'GET',
        CONFIG.HOST_SETTINGS.OAUTH_SERVER.PROTOCOL,
        CONFIG.HOST_SETTINGS.OAUTH_SERVER.HOST,
        CONFIG.HOST_SETTINGS.OAUTH_SERVER.PORT,
        '/tokeninfo',
        {
            access_token: accessToken
        }
    );

    request(options, function (e, r, token) {
        const err = logger.logRequestAndResponse(e, options, r, token);

        if (err) {
            return callback(err);
        }

        let isValid = false;

        if (token && new Date(token.accessTokenExpiresAt) > new Date()) {
            isValid = true;
        }
        else {
            logger.warn('[auth_service_adapter] access token expired');
        }

        return callback(null, isValid, token);

    });


};

module.exports = self;