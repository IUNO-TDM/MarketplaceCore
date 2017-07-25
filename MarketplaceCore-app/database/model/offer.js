/**
 * Created by beuttlerma on 31.05.17.
 */

var logger = require('../../global/logger');
var db = require('../db_connection');

/**
 *
 * Builds a user object from a database response
 *
 * @param data
 * @constructor
 */
function Offer(data) {
    if (data) {
        this.offeruuid = data.offeruuid;
        this.paymentinvoiceuuid = data.paymentinvoiceuuid;
        this.createdat = data.createdat;
        this.createdby = data.createdby;
    }
}

Offer.prototype.FindAll = Offer.FindAll = function () {
    throw {name: "NotImplementedError", message: "Function not implemented yet"}; //TODO: Implement this function if needed
};

Offer.prototype.FindSingle = Offer.FindSingle = function (userUUID, roleName, id, callback) {

    db.func('GetOfferByID', [id, userUUID, roleName])
        .then(function (data) {
            if (data && data.length) {
                data = data[0];
            }
            callback(null, new Offer(data))
        })
        .catch(function (error) {
            logger.crit(error);
            callback(error);
        });
};

Offer.prototype.FindByRequest = Offer.FindByRequest = function (userUUID, offerRequestUUID, callback) {

    db.func('GetOfferByRequestID', [offerRequestUUID, userUUID])
        .then(function (data) {
            if (data && data.length) {
                data = data[0];
            }
            callback(null, new Offer(data));
        })
        .catch(function (error) {
            logger.crit(error);
            callback(error);
        });
};

Offer.prototype.FindByPaymentInvoice = Offer.FindByPaymentInvoice = function (userUUID, paymentInvoiceUUID, callback) {

    db.func('GetOfferForPaymentInvoice', [paymentInvoiceUUID, userUUID])
        .then(function (data) {
            if (data && data.length) {
                data = data[0];
            }
            callback(null, new Offer(data));
        })
        .catch(function (error) {
            logger.crit(error);
            callback(error);
        });
};



module.exports = Offer;