/**
 * Created by beuttlerma on 18.04.17.
 */

String.prototype.format = function () {
    var args = [].slice.call(arguments);
    return this.replace(/(\{\d+\})/g, function (a) {
        return args[+(a.substr(1, a.length - 2)) || 0];
    });
};

var self = {};


// ---- Database Credentials ----

var username = 'username';
var password = 'password';
var host = 'host';
var port = 5432;
var database = 'database';

// ---- CONFIGURATION EXPORT ----

self.HOST_SETTINGS = {
    OAUTH_SERVER: {
        PROTOCOL: 'http',
        HOST: 'localhost',
        PORT: 3006
    },
    PAYMENT_SERVICE: {
        PROTOCOL: 'http',
        HOST: 'localhost',
        PORT: 8080
    },
    BIT_COIN_VAULT: {
        PROTOCOL: 'http',
        HOST: 'localhost',
        PORT: 8081
    },
    LICENSE_CENTRAL: {
        PROTOCOL: 'https',
        HOST: 'lc-admin.codemeter.com/26959-02/marketplaceapi',
        PORT: 443
    }
};

self.DB_CONNECTION_STRING = 'postgres://{0}:{1}@{2}:{3}/{4}'.format(username, password, host, port, database);
self.LOG_LEVEL = 'debug';

self.OAUTH_CREDENTIALS = {
    CLIENT_ID: '',
    CLIENT_SECRET: ''
};

self.LICENSE_CENTRAL = {
    BASIC_AUTH: {
        USER: '',
        PASSWORD: ''
    },
    CERT: {
        CERT_FILE_PATH: '',
        KEY_FILE_PATH: '',
        P12_FILE_PATH: '',
        PASS_PHRASE: ''
    },
    FIRM_CODE: 6000274,
    CMACTID: 1000,
    LCACTION:'autoupdate'
};

self.USER = {
    uuid: '{uuid}',
    roles: ['{role}']
};

self.PRODUCT_CODE_PREFIX = 'pc';

module.exports = self;