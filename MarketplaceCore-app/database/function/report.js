/**
 * Created by beuttlerma on 31.05.17.
 */

var logger = require('../../global/logger');
var db = require('../db_connection');

var self = {};

self.GetTotalRevenue = function (from, to, technologyUUID, detail, userUUID, roles, callback) {
    db.func('GetTotalRevenue', [from, to, technologyUUID, detail, userUUID, roles])
        .then(function (data) {
            logger.debug(data);
            callback(null, data);
        })
        .catch(function (error) {
            logger.crit(error);
            callback(error);
        });
};

self.GetTotalUserRevenue = function (from, to, technologyUUID, userUUID, roles, callback) {
    db.func('GetTotalUserRevenue', [from, to, technologyUUID, userUUID, roles])
        .then(function (data) {
            logger.debug(data);
            callback(null, data);
        })
        .catch(function (error) {
            logger.crit(error);
            callback(error);
        });
};

self.GetRevenueHistory = function (from, to, technologyUUID, userUUID, roles, callback) {
    db.func('GetRevenueHistory', [from, to, technologyUUID, userUUID, roles])
        .then(function (data) {
            logger.debug(data);
            callback(null, data);
        })
        .catch(function (error) {
            logger.crit(error);
            callback(error);
        });
};

self.GetTopTechnologyData = function (from, to, technologyUUID, limit, user, roles, callback) {
    db.func('GetTopTechnologyData', [from, to, technologyUUID, limit, user, roles])
        .then(function (data) {
            logger.debug(data);
            callback(null, data);
        })
        .catch(function (error) {
            logger.crit(error);
            callback(error);
        });
};

self.GetTopComponents = function (from, to, technologyUUID, limit, userUUID, lang, roles, callback) {
    db.func('GetTopComponents', [from, to, technologyUUID, limit, userUUID, lang, roles])
        .then(function (data) {
            logger.debug(data);
            callback(null, data);
        })
        .catch(function (error) {
            logger.crit(error);
            callback(error);
        });
}

self.GetTechnologyDataHistory = function (from, to, technologyUUID, userUUID, roles, callback) {
    db.func('GetTechnologyDataHistory', [from, to, technologyUUID, userUUID, roles])
        .then(function (data) {
            logger.debug(data);
            callback(null, data);
        })
        .catch(function (error) {
            logger.crit(error);
            callback(error);
        });
};

module.exports = self;