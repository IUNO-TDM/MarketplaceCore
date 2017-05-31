/**
 * Created by beuttlerma on 31.05.17.
 */


var pgp = require('pg-promise')();
var config = require('../config/config_loader');
var self = {};

self.db = pgp(config.DB_CONNECTION_STRING);

module.exports = self;