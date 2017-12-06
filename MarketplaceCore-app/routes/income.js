const express = require('express');
const router = express.Router();
const logger = require('../global/logger');
const validate = require('express-jsonschema').validate;

const validation_schema = require('../schema/income_schema');
const vault_service = require('../services/bitcoinvault_service');

var async = require('async');

router.get('/:userId', validate({
    query: validation_schema.Empty,
    body: validation_schema.Empty
}), function (req, res, next) {
    vault_service.getWalletsForUserId(req.param('userId'), '4711', function (err, wallets) {

        if (err) {
            res.status(404).send(err);
        } else {
            var iterateForBalance = function (wallet, done) {
                vault_service.getCreditForWallet(wallet, '4711', function (err, balance) {
                    done(err, balance);
                });
            };

            async.concatSeries(wallets, iterateForBalance, function (err, balances) {
                if (err) {
                    res.status(500).send(err);
                } else {
                    var totalbalance = 0;
                    for (var balance in balances) {
                        totalbalance += balance;
                    }
                    res.send(totalbalance);
                }

            });
        }
    })

});