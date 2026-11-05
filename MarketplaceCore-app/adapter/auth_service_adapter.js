const logger = require('../global/logger');
const CONFIG = require('../config/config_loader');
const request = require('request');

const self = {};
const cache = new Map();

function mapIntrospection(result) {
    const roles = (result.realm_access && Array.isArray(result.realm_access.roles)) ? result.realm_access.roles : [];
    const clientId = result.client_id || result.azp;

    return {
        accessTokenExpiresAt: new Date(result.exp * 1000).toISOString(),
        user: {
            id: result.sub,
            uuid: result.sub,
            roles: roles
        },
        client: {
            id: clientId
        }
    };
}

function cacheGet(accessToken) {
    const entry = cache.get(accessToken);

    if (!entry) {
        return null;
    }

    if (entry.until < Date.now() || new Date(entry.token.accessTokenExpiresAt) <= new Date()) {
        cache.delete(accessToken);
        return null;
    }

    return entry.token;
}

function cacheSet(accessToken, token) {
    if (cache.size > 1000) {
        cache.clear();
    }

    cache.set(accessToken, {token: token, until: Date.now() + CONFIG.OAUTH.CACHE_SECONDS * 1000});
}

self.validateToken = function (accessToken, callback) {
    if (typeof(callback) !== 'function') {
        callback = function () {
            logger.info('Callback not registered');
        };
    }

    const cached = cacheGet(accessToken);
    if (cached) {
        return callback(null, true, cached);
    }

    const options = {
        method: 'POST',
        url: CONFIG.OAUTH.INTROSPECTION_URL,
        form: {token: accessToken, token_type_hint: 'access_token'},
        json: true,
        auth: {
            user: CONFIG.OAUTH.CLIENT_ID,
            pass: CONFIG.OAUTH.CLIENT_SECRET
        }
    };

    request(options, function (e, r, result) {
        if (e || !r || r.statusCode !== 200 || !result) {
            logger.warn('[auth_service_adapter] token introspection failed: ' + (e ? e.message : (r && r.statusCode)));
            return callback(e || new Error('Token introspection failed'), false);
        }

        if (result.active !== true || !result.sub || !result.exp) {
            logger.warn('[auth_service_adapter] access token inactive');
            return callback(null, false);
        }

        const token = mapIntrospection(result);

        if (new Date(token.accessTokenExpiresAt) <= new Date()) {
            return callback(null, false);
        }

        cacheSet(accessToken, token);
        return callback(null, true, token);
    });
};

module.exports = self;
