/**
 * Created by beuttlerma on 11.07.17.
 */

var authService= require('../connector/auth_service_connector');
var logger = require('../global/logger');
var self = {};

function getBearerTokenFromHeader(req) {
    if (!req.headers || typeof req.headers !== 'object') {
        throw new TypeError('argument req is required to have headers property')
    }

    if (req.headers.authorization && !req.headers.authorization.startsWith('Bearer')) {
        throw new Error('Bearer token missing')
    }

    var token = req.headers.authorization.split('Bearer ')[1];

    if (!token) {
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

module.exports = self;