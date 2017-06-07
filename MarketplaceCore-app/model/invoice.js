/**
 * Created by beuttlerma on 13.04.17.
 */

var Transfer = require('./transfer');

/**
 *
 * @param totalAmount
 * @param expiration
 * @param transfers
 * @param invoiceId
 * @param referenceId
 * @constructor
 */
function Invoice(totalAmount, expiration, transfers, invoiceId, referenceId) {
    this.totalAmount = totalAmount;
    this.expiration = expiration;
    this.transfers = transfers;
    this.invoiceId = invoiceId;
    this.referenceId = referenceId;
}

/**
 *
 * Creates a new invoice object from a given json object. Only parses relevant data into the new object.
 *
 * @param jsonData
 * @returns {*}
 * @constructor
 */
Invoice.prototype.CreateFromJSON = function (jsonData) {
    if (!jsonData) {
        return null;
    }

    return new Invoice(
        jsonData['totalAmount'],
        jsonData['expiration'],
        new Transfer().CreateListFromJSON(jsonData['transfers']),
        jsonData['invoiceId'],
        jsonData['referenceId']
    );
};

module.exports = Invoice;