/**
 * Created by beuttlerma on 31.05.17.
 */

var logger = require('../../global/logger');
var db = require('../db_connection');

var self = {};

self.GetActivatedLicensesSince = function (userUUID, sinceDate, callback) {
    db.func('GetActivatedLicensesSince',[sinceDate, userUUID])
        .then(function (data) {
            logger.debug(data);
            callback(null, data);
        })
        .catch(function (error) {
            logger.crit(error);
            callback(error);
        });
};

self.GetTopTechnologyDataSince = function(userUUID, sinceDate, topValue, callback){
    db.func('GetTopTechnologyDataSince', [sinceDate, topValue, userUUID])
        .then(function (data) {
            logger.debug(data);
            callback(null, data);
        })
        .catch(function (error) {
            logger.crit(error);
            callback(error);
        });
};

self.GetWorkloadSince = function(userUUID, sinceDate, callback){
    db.func('GetWorkloadSince', [sinceDate, userUUID])
        .then(function (data) {
            logger.debug(data);
            callback(null, data);
        })
        .catch(function (error) {
            logger.crit(error);
            callback(error);
        });
};

self.GetMostUsedComponents = function(userUUID, sinceDate, topValue, callback){
    db.func('GetMostUsedComponents', [sinceDate, topValue, userUUID])
        .then(function (data) {
            logger.debug(data);
            callback(null, data);
        })
        .catch(function (error) {
            logger.crit(error);
            callback(error);
        });
};

self.GetRevenuePerHour = function(userUUID, sinceDate, callback){
    db.func('GetRevenuePerHourSince', [sinceDate, userUUID])
        .then(function (data) {
            logger.debug(data);
            callback(null, data);
        })
        .catch(function (error) {
            logger.crit(error);
            callback(error);
        });
};

self.GetRevenuePerDay = function(userUUID, sinceDate, callback){
    db.func('GetRevenuePerDaySince', [sinceDate, userUUID])
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