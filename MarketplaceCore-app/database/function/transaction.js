/**
 * Created by beuttlerma on 31.05.17.
 */

var logger = require('../../global/logger');
var db = require('../db_connection');

var self = {};

self.GetTransactionByOfferRequest = function (userUUID, roleName, offerRequestUUID, callback) {
    db.func('GetTransactionByOfferRequest', [offerRequestUUID, userUUID, roleName])
        .then(function (data) {
            callback(null, data);
        })
        .catch(function (error) {
            logger.crit(error);
            callback(error);
        });
};

//Get all transaction by given OfferRequest
self.GetTransactionByID = function (userUUID, transactionUUID, callback) {
    db.func('GetTransactionByID', [transactionUUID, userUUID])
        .then(function (data) {
            if (data && data.length) {
                data = data[0];
            }
            callback(null, data);
        })
        .catch(function (error) {
            logger.crit(error);
            callback(error);
        });
};

module.exports = self;