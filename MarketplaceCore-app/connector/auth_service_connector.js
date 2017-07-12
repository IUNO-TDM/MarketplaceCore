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

self.validateToken = function (userUUID, token, callback) {
    var tokenValid = false;

    if (typeof(callback) !== 'function') {

        callback = function () {
            logger.info('Callback not regis§tered');
        }
    }

    var options = buildOptionsForRequest(
        'GET',
        'http',
        CONFIG.HOST_SETTINGS.OAUTH_SERVER.HOST,
        CONFIG.HOST_SETTINGS.OAUTH_SERVER.PORT,
        '/tokeninfo',
        {
            access_token: token
        }
    );

    request(options, function (e, r, tokenInfo) {
        var err = logger.logRequestAndResponse(e, options, r, tokenInfo);

        if (err) {
            return callback(err);
        }

        tokenValid = tokenInfo.useruuid === userUUID;
        tokenValid = tokenValid && new Date(tokenInfo.expires) > new Date();

        callback(err, tokenValid)
    });


}

module.exports = self;