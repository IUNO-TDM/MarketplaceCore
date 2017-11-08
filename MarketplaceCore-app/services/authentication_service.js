/**
 * Created by beuttlerma on 11.07.17.
 */

var authService= require('../adapter/auth_service_adapter');
var logger = require('../global/logger');
var self = {};

function getBearerTokenFromHeader(req) {
    var token;

    if (req.headers && typeof req.headers === 'object') {
        if (req.headers.authorization && req.headers.authorization.startsWith('Bearer')) {
            try {
                token = req.headers.authorization.split('Bearer ')[1];
            }
            catch (err) {

            }
        }
    }

    if (!token) {
        logger.info('Missing Header: Authentication: Bearer {Access_Token}');
        throw new Error('Bearer token missing');
    }

    return token;

}

function unauthorized(res) {
    res.set('WWW-Authenticate', 'Bearer realm=Valid oauth token required"');
    return res.sendStatus(401);
}


self.oAuth = function(req, res, next) {

    try {
        var accessToken = getBearerTokenFromHeader(req);

        authService.validateToken(req.query['userUUID'], accessToken, function(err, isValid, token){
            if (isValid) {
                req.token = token;
                next();
            }
            else {
                return unauthorized(res);
            }
        })

    }
    catch (ex) {
        logger.warn(ex);
        return unauthorized(res);
    }
};

self.ws_oAuth = function (socket, next) {
    try {
        const accessToken = getBearerTokenFromHeader(socket.handshake);

        authService.validateToken(accessToken, function (err, isValid, token) {
            if (isValid) {
                next();
            }
            else {
                return next(new Error('WWW-Authenticate: Bearer realm=Valid oauth token required'));
            }
        })

    }
    catch (ex) {
        logger.warn(ex);

        return next(new Error('WWW-Authenticate: Bearer realm=Valid oauth token required'));
    }
};

module.exports = self;