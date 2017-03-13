/**
 * Created by beuttlerma on 03.03.17.
 */

var queries = require('../connectors/pg-queries');

var payment_service = require('./payment_service');
var self = {};



self.generateInvoice = function (request,transaction, callback) {


    var invoice = {
        totalAmount: 100000 ,
        referenceId: transaction.otransactionuuid,
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
    

    //
    // var invoice = {
    //     totalAmount: 100000 ,
    //     referenceId: transaction.otransactionuuid,
    //     expiration: new Date(new Date().getTime() + (2 * 60 * 60 * 1000)).toISOString(),
    //     transfers: [
    //
    //         {
    //             address: 'mqN3sB5jo3r4aDRmXHHQZMf9tCwP1zMzce',
    //             coin: 70000
    //         }
    //     ]
    // };



};


module.exports = self;