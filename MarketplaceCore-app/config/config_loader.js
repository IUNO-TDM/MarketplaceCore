/**
 * Configuration is read from environment variables only (see contracts/configuration.md).
 *
 * Required: DB_PASSWORD, BACKEND_CLIENT_SECRET
 * Optional: DB_HOST (localhost), DB_PORT (5432), DB_USER (marketplace), DB_NAME (MarketplaceCore),
 *           KEYCLOAK_INTERNAL_URL (http://localhost:8080), KEYCLOAK_REALM (iuno),
 *           BACKEND_CLIENT_ID (marketplace-backend), LOG_LEVEL (info), IMAGE_DIR (images/recipes/)
 */
const path = require('path');
const env = process.env;

function required(name) {
    if (!env[name]) {
        throw new Error('Missing required environment variable: ' + name);
    }

    return env[name];
}

const self = {};

self.DB_CONNECTION = {
    host: env.DB_HOST || 'localhost',
    port: parseInt(env.DB_PORT, 10) || 5432,
    database: env.DB_NAME || 'MarketplaceCore',
    user: env.DB_USER || 'marketplace',
    password: required('DB_PASSWORD')
};

const keycloakUrl = (env.KEYCLOAK_INTERNAL_URL || 'http://localhost:8080').replace(/\/+$/, '');
self.OAUTH = {
    INTROSPECTION_URL: keycloakUrl + '/realms/' + encodeURIComponent(env.KEYCLOAK_REALM || 'iuno') +
        '/protocol/openid-connect/token/introspect',
    CLIENT_ID: env.BACKEND_CLIENT_ID || 'marketplace-backend',
    CLIENT_SECRET: required('BACKEND_CLIENT_SECRET'),
    CACHE_SECONDS: parseInt(env.TOKEN_CACHE_SECONDS, 10) || 30
};

self.LOG_LEVEL = env.LOG_LEVEL || 'info';

self.TMP_DIR = path.resolve(__dirname, '../tmp');
self.FILE_DIR = path.resolve(__dirname, '../files');
self.IMAGE_DIR = env.IMAGE_DIR || 'images/recipes/';
self.DEFAULT_IMAGE = 'images/default.svg';

module.exports = self;
