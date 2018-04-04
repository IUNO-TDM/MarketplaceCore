/**
 * Created by beuttlerma on 31.05.17.
 */

const logger = require('../../global/logger');
const db = require('../db_connection');

const self = {};

self.GetTransactionByOfferRequest = function (userUUID, roles, offerRequestUUID, callback) {
    db.func('GetTransactionByOfferRequest', [offerRequestUUID, userUUID, roles])
        .then(function (data) {
            if (data && data.length) {
                return callback(null, data[0]);
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

//Get all transaction by given OfferRequest
self.GetTransactionByID = function (user, transactionUUID, callback) {
    db.func('GetTransactionById', [transactionUUID, user.uuid, user.roles])
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

self.GetTransactionByOffer = function (userUUID, roles, offerUUID, callback) {
    db.func('GetTransactionByOffer', [offerUUID, userUUID, roles])
        .then(function (data) {
            if (data && data.length) {
                return callback(null, data[0]);
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