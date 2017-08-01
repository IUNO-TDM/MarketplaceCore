/**
 * Created by beuttlerma on 31.05.17.
 */

var logger = require('../../global/logger');
var db = require('../db_connection');

var self = {};

self.GetTransactionByOfferRequest = function (userUUID, roles, offerRequestUUID, callback) {
    db.func('GetTransactionByOfferRequest', [offerRequestUUID, userUUID, roles])
        .then(function (data) {
            callback(null, data);
        })
        .catch(function (error) {
            logger.crit(error);
            callback(error);
        });
};

//Get all transaction by given OfferRequest
self.GetTransactionByID = function (user, transactionUUID, callback) {
    db.func('GetTransactionById', [transactionUUID, user.uuid, user.role])
        .then(function (data) {
            if (data && data.length) {
                data = data[0];
                return callback(null, data);
            }
            else {
                return callback(null, null);
            }
        })
        .catch(function (error) {
            logger.crit(error);
            callback(error);
        });
};

module.exports = self;