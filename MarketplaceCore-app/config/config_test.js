
String.prototype.format = function () {
    var args = [].slice.call(arguments);
    return this.replace(/(\{\d+\})/g, function (a) {
        return args[+(a.substr(1, a.length - 2)) || 0];
    });
};

var self = {};


// ---- Database Credentials ----

var username = 'postgres';
var password = 're7ahpheibaiweey';
var host = 'test-tdm.fritz.box';
var port = '5432';
var database = 'intechdb';

// ---- CONFIGURATION EXPORT ----

self.HOST_SETTINGS = {
    OAUTH_SERVER: {
        PROTOCOL: 'http',
        HOST: 'test-tdm.fritz.box',
        PORT: 3006
    }
};

self.DB_CONNECTION_STRING = 'postgres://{0}:{1}@{2}:{3}/{4}'.format(username, password, host, port, database);
self.LOG_LEVEL = 'debug';
self.OAUTH_CREDENTIALS = {
    CLIENT_ID: '9f400def-9680-4ad1-a228-00724dbbd983',
    CLIENT_SECRET: 'ce0eabeb-123b-45f7-931f-3a9d535c23a9'
};

module.exports = self;