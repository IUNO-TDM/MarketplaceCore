const AbstractClientStore = require('express-brute/lib/AbstractClientStore'),
    humps = require('humps'),
    moment = require('moment'),
    util = require('util'),
    _ = require('lodash');

const PgStore = module.exports = function (options) {
    AbstractClientStore.apply(this, arguments);

    this.options = _.extend({}, PgStore.defaults, options);
    this.db = options.db; // allow passing in native pg client
};

PgStore.prototype = Object.create(AbstractClientStore.prototype);

PgStore.prototype.set = function (key, value, lifetime, callback) {
    const self = this;

    let expiry;

    if (lifetime) {
        expiry = moment().add(lifetime, 'seconds').toDate();
    }

    self.db.result(
        util.format('UPDATE "%s"."%s" SET "count" = $1, "last_request" = $2, "expires" = $3 WHERE "id" = $4',
            self.options.schemaName, self.options.tableName),
        [value.count, value.lastRequest, expiry, key])
        .then(function (result) {
            if (!result.rowCount) {
                return self.db.result(util.format('INSERT INTO "%s"."%s" ("id", "count", "first_request", "last_request", "expires") VALUES ($1, $2, $3, $4, $5)',
                    self.options.schemaName, self.options.tableName),
                    [key, value.count, value.firstRequest, value.lastRequest, expiry])
                    .then(function (result) {
                        return typeof callback === 'function' && callback(null);
                    }).catch(function (err) {
                        return typeof callback === 'function' && callback(err);
                    });
            }

            return typeof callback === 'function' && callback(null);
        })
        .catch(function (err) {
            return typeof callback === 'function' && callback(err);
        });
};

PgStore.prototype.get = function (key, callback) {
    const self = this;

    self.db.result(
        util.format('SELECT "id", "count", "first_request", "last_request", "expires" FROM "%s"."%s" WHERE "id" = $1',
            self.options.schemaName, self.options.tableName),
        [key])
        .then(function (result) {
            if (result.rows.length && new Date(result.rows[0].expires).getTime() < new Date().getTime()) {

                return self.db.result(util.format('DELETE FROM "%s"."%s" WHERE "id" = $1',
                    self.options.schemaName, self.options.tableName),
                    [key])
                    .then(function (result) {
                        return typeof callback === 'function' && callback(null);
                    }).catch(function (err) {
                        return typeof callback === 'function' && callback(err);
                    });
            }

            return typeof callback === 'function' && callback(null, result.rowCount ? humps.camelizeKeys(result.rows[0]) : null);
        })
        .catch(function (err) {
            return typeof callback === 'function' && callback(err);
        });
};

PgStore.prototype.reset = function (key, callback) {
    const self = this;


    return self.db.result(util.format('DELETE FROM "%s"."%s" WHERE "id" = $1 RETURNING *',
        self.options.schemaName, self.options.tableName),
        [key])
        .then(function (result) {
            return typeof callback === 'function' && callback(null, result.length ? humps.camelizeKeys(result[0]) : null);
        }).catch(function (err) {
            return typeof callback === 'function' && callback(err, null);
        });

};

PgStore.defaults = {
    schemaName: 'public',
    tableName: 'brute'
};
