const express = require('express');
const router = express.Router();
const logger = require('../global/logger');
const validate = require('express-jsonschema').validate;

const validation_schema = require('../schema/vault_schema');
const vault_service = require('../services/bitcoinvault_service');

var async = require('async');

router.get('/:userId/cumulated', validate({
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
                    var totalbalance = parseInt(0);
                    for (var balance in balances) {
                        totalbalance += parseInt(balances[balance]);
                    }
                    res.status(200).send(totalbalance.toString());
                }

            });
        }
    })
});
router.get('/:userId/wallets', validate({
    query: validation_schema.Empty,
    body: validation_schema.Empty
}), function (req, res, next) {
    vault_service.getWalletsForUserId(req.param('userId'), '4711', function (err, wallets) {

        if (err) {
            res.status(404).send(err);
        } else {
            var iterateForBalance = function (wallet, done) {
                vault_service.getCreditForWallet(wallet, '4711', function (err, unconfirmed) {
                    if(err){
                        done(err,null);
                    }else{
                        vault_service.getConfirmedCreditForWallet(wallet,'4711', function(err, confirmed){
                            done(err, {walletId: wallet, unconfirmed: unconfirmed, confirmed:confirmed});
                        });

                    }

                });
            };

            async.concatSeries(wallets, iterateForBalance, function (err, balances) {
                if (err) {
                    res.status(500).send(err);
                } else {
                    res.status(200).send(balances);
                }

            });
        }
    })
});

router.post('/:userId/wallets/:walletId/payouts', validate({
    query: validation_schema.Empty,
    body: validation_schema.Payout
}),function(req, res, next)
{
    var userId = req.param('userId');
    var walletId = req.param('walletId');
    var payout = req.body;
    vault_service.getWalletsForUserId(userId, '4711', function (err, wallets) {
        if (err) {
            res.sendStatus(400);
        }
        else if (wallets.indexOf(walletId) == 1) {
            res.status(404).send('The wallet does not exist or does not own this user');
        } else {
            vault_service.payoutCredit(walletId, payout.amount, payout.payoutAddress, '4711', payout.emptyWallet, payout.referenceId, function (err, payout) {
                if (err) {
                    res.status(500).send(err);
                } else {
                    res.send(payout);
                }
            });
        }
    });

});

module.exports = router;