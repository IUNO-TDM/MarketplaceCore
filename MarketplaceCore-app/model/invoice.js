/**
 * Created by beuttlerma on 13.04.17.
 */

var Transfer = require('./transfer');

function Invoice(totalAmount, expiration, transfers, invoiceId, referenceId) {
    this.totalAmount = totalAmount;
    this.expiration = expiration;
    this.transfers = transfers;
    this.invoiceId = invoiceId;
    this.referenceId = referenceId;
}

Invoice.prototype.CreateFromJSON = function (jsonData) {
    return new Invoice(
        jsonData['totalAmount'],
        jsonData['expiration'],
        new Transfer().CreateListFromJSON(jsonData['transfers']),
        jsonData['invoiceId'],
        jsonData['referenceId']
    );
};

module.exports = Invoice;