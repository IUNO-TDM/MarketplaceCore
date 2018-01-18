/**
 * Created by beuttlerma on 03.03.17.
 */

var payment_service = require('./payment_service');
var self = {};
var license = require('./../database/function/license');
var async = require('async');
var vault_service = require('./bitcoinvault_service');
var Transfer = require('../model/transfer');
var TechnologyData = require('../database/model/technologydata')

var calculateLicenseFeeWithoutProvision = function (userUUID, licenseFee) {
    return licenseFee * 0.7;
}

self.generateInvoice = function (userUUID, request, transaction, roles, callback) {

    var items = request.result.items;
    var totalAmount = 0;


    var iterator = function (item, done) {
        license.GetLicenseFeeByTechnologyData(userUUID, item.technologydatauuid, roles, function (err, licenseFee) {
            if (err) {
                done(err, null);
            } else {
                TechnologyData.FindSingle(userUUID, roles, item.technologydatauuid, function (err, techData) {
                    if (err) {
                        done(err, null);
                    } else {
                        vault_service.getWalletsForUserId(techData.createdby, '4711', function (err, wallets) {
                            //if err
                            if (err) {
                                done(err, null);
                            } else {
                                var getAddress = function (walletId) {
                                    vault_service.getNewAddressForWallet(walletId, '4711', function (err, address) {
                                        if (err) {
                                            done(err);
                                        } else {
                                            var lf = calculateLicenseFeeWithoutProvision(techData.createdby, licenseFee);
                                            done(null, [{fee: licenseFee, transfer: new Transfer(address, lf)}]);
                                        }
                                    });
                                };

                                if (!wallets || wallets.length < 1) {
                                    //create a wallet for this user
                                    vault_service.createWalletForUserId(techData.createdby, '4711', function (err, wId) {
                                        if (err) {
                                            done(err, null);
                                        }
                                        else {
                                            getAddress(wId);
                                        }
                                    })
                                } else {
                                    getAddress(wallets[0]);
                                }
                            }

                        });
                    }

                });
            }
        })
    };

    async.concatSeries(items, iterator, function (err, itemlist) {
        var transfers = [];
        for (var i in itemlist) {
            totalAmount += itemlist[i].fee;
            transfers.push(itemlist[i].transfer);
        }
        // our virtual currency IUNO represents 1 milli bitcoin
        // totalAmount *= 100000;
        // 2017.08.21 - The conversion is no longer needed since this is already done at input time.


        var invoice = {
            totalAmount: totalAmount,
            referenceId: transaction.transactionuuid,
            expiration: new Date(new Date().getTime() + (2 * 60 * 60 * 1000)).toISOString(),
            transfers: transfers
        };

        payment_service.createLocalInvoice(invoice, function (e, invoice) {

            if (e) {
                return callback(e);
            }

            payment_service.getInvoiceTransfers(invoice, function (e, transfers) {
                var res = {
                    totalAmount: invoice.totalAmount,
                    invoiceId: invoice.invoiceId,
                    referenceId: invoice.referenceId,
                    expiration: invoice.expiration,
                    transfers: transfers
                };
                callback(null, res);
            });

        });
    });

};


module.exports = self;