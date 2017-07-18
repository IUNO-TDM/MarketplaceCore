/**
 * Created by beuttlerma on 03.03.17.
 */

var payment_service = require('./payment_service');
var self = {};

self.generateInvoice = function (request,transaction, roleName, callback) {



    var invoice = {
        totalAmount: 100000 ,
        referenceId: transaction.transactionuuid,
        expiration: new Date(new Date().getTime() + (2 * 60 * 60 * 1000)).toISOString(),
        transfers: []
    };
    
    payment_service.createLocalInvoice(invoice, function (e, invoice) {
        
        payment_service.getInvoiceTransfers(invoice, function (e,transfers) {
            var res = {
                totalAmount: invoice.totalAmount,
                invoiceId: invoice.invoiceId,
                referenceId: invoice.referenceId,
                expiration: invoice.expiration,
                transfers: transfers
            };
            callback(null,res);
        });

    });
};


module.exports = self;