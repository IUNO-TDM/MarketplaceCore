/**
 * Created by beuttlerma on 31.05.17.
 */

var logger = require('../../global/logger');
var db = require('../db_connection');

var self = {};

self.GetActivatedLicensesSince = function (userUUID, rolename, sinceDate, callback) {
    db.func('GetActivatedLicensesSince',[sinceDate, userUUID, rolename])
        .then(function (data) {
            logger.debug(data);
            callback(null, data);
        })
        .catch(function (error) {
            logger.crit(error);
            callback(error);
        });
};

self.GetTopTechnologyDataSince = function(userUUID, rolename, sinceDate, topValue, callback){
    db.func('GetTopTechnologyDataSince', [sinceDate, topValue, userUUID, rolename])
        .then(function (data) {
            logger.debug(data);
            callback(null, data);
        })
        .catch(function (error) {
            logger.crit(error);
            callback(error);
        });
};

self.GetWorkloadSince = function(userUUID, rolename, sinceDate, callback){
    db.func('GetWorkloadSince', [sinceDate, userUUID, rolename])
        .then(function (data) {
            logger.debug(data);
            callback(null, data);
        })
        .catch(function (error) {
            logger.crit(error);
            callback(error);
        });
};

self.GetMostUsedComponents = function(userUUID, rolename, sinceDate, topValue, callback){
    db.func('GetMostUsedComponents', [sinceDate, topValue, userUUID, rolename])
        .then(function (data) {
            logger.debug(data);
            callback(null, data);
        })
        .catch(function (error) {
            logger.crit(error);
            callback(error);
        });
};

self.GetRevenuePerHour = function(userUUID, rolename, sinceDate, callback){
    db.func('GetRevenuePerHourSince', [sinceDate, userUUID, rolename])
        .then(function (data) {
            logger.debug(data);
            callback(null, data);
        })
        .catch(function (error) {
            logger.crit(error);
            callback(error);
        });
};

self.GetRevenuePerDay = function(userUUID, rolename, sinceDate, callback){
    db.func('GetRevenuePerDaySince', [sinceDate, userUUID, rolename])
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