/**
 * Created by beuttlerma on 31.05.17.
 */

var logger = require('../../global/logger');
var db = require('../db_connection');

var self = {};

self.GetActivatedLicensesSince = function (userUUID, roles, sinceDate, callback) {
    db.func('GetActivatedLicensesSince',[sinceDate, userUUID, roles])
        .then(function (data) {
            logger.debug(data);
            callback(null, data);
        })
        .catch(function (error) {
            logger.crit(error);
            callback(error);
        });
};

self.GetTopTechnologyDataSince = function(userUUID, roles, sinceDate, topValue, callback){
    db.func('GetTopTechnologyDataSince', [sinceDate, topValue, userUUID, roles])
        .then(function (data) {
            logger.debug(data);
            callback(null, data);
        })
        .catch(function (error) {
            logger.crit(error);
            callback(error);
        });
};

self.GetWorkloadSince = function(userUUID, roles, sinceDate, callback){
    db.func('GetWorkloadSince', [sinceDate, userUUID, roles])
        .then(function (data) {
            logger.debug(data);
            callback(null, data);
        })
        .catch(function (error) {
            logger.crit(error);
            callback(error);
        });
};

self.GetMostUsedComponents = function(userUUID, roles, sinceDate, topValue, callback){
    db.func('GetMostUsedComponents', [sinceDate, topValue, userUUID, roles])
        .then(function (data) {
            logger.debug(data);
            callback(null, data);
        })
        .catch(function (error) {
            logger.crit(error);
            callback(error);
        });
};

self.GetRevenuePerHour = function(userUUID, roles, sinceDate, callback){
    db.func('GetRevenuePerHourSince', [sinceDate, userUUID, roles])
        .then(function (data) {
            logger.debug(data);
            callback(null, data);
        })
        .catch(function (error) {
            logger.crit(error);
            callback(error);
        });
};

self.GetRevenuePerDay = function(userUUID, roles, sinceDate, callback){
    db.func('GetRevenuePerDaySince', [sinceDate, userUUID, roles])
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