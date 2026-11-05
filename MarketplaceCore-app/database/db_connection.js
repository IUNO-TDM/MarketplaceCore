const pgp = require('pg-promise')();
const config = require('../config/config_loader');

module.exports = pgp(config.DB_CONNECTION);
