/**
 * Created by beuttlerma on 03.03.17.
 */

var payment_service = require('./payment_service');
var self = {};
var license = require('./../database/function/license');
var async = require('async');

self.generateInvoice = function (userUUID, request,transaction, roles, callback) {

    var items = request.result.items;
    var totalAmount = 0;


    var iterator = function(item, done){
        license.GetLicenseFeeByTechnologyData(userUUID,item.technologydatauuid,roles,function (err, licenseFee) {
            if (err) {
                done(err,null);
            }else{
                done(null,[item.amount*licenseFee]);
            }
        })
    };

    async.concatSeries(items, iterator, function(err, res) {
        console.log(res); // [1, 3, 2]
        for(var fee in res){
            totalAmount += res[fee];
        }

        var invoice = {
            totalAmount: totalAmount ,
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
    });

};


module.exports = self;