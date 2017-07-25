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
        HOST: 'localhost',
        PORT: 3006
    }
};

self.DB_CONNECTION_STRING = 'postgres://{0}:{1}@{2}:{3}/{4}'.format(username, password, host, port, database);
self.LOG_LEVEL = 'debug';
self.USER_UUID = '16f69912-d6be-4ef0-ada8-2c1c75578b51';
self.OAUTH_CREDENTIALS = {
    CLIENT_ID: '',
    CLIENT_SECRET: ''
};


module.exports = self;