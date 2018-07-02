const express = require('express');
const router = express.Router();
const logger = require('../global/logger');
const authenticationService = require('../services/authentication_service');


const {Validator, ValidationError} = require('express-json-validator-middleware');
const validator = new Validator({allErrors: true});
const validation_schema = require('../schema/vault_schema');
const validate = validator.validate;


const vault_service = require('../services/bitcoinvault_service');
const bruteForceProtection = require('../services/brute_force_protection');

const async = require('async');

router.use('/users/:userId/', authenticationService.paramIsEqualToSessionUser('userId'));

router.get('/users/:userId/balance', validate({
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
router.get('/users/:userId/wallets', validate({
    query: validation_schema.Empty,
    body: validation_schema.Empty
}), function (req, res, next) {
    vault_service.getWalletsForUserId(req.param('userId'), '4711', function (err, wallets) {

        if (err) {
            res.status(404).send(err);
        } else {
            const iterateForBalance = function (wallet, done) {
                vault_service.getCreditForWallet(wallet, '4711', function (err, unconfirmed) {
                    if (err) {
                        done(err, null);
                    } else {
                        vault_service.getConfirmedCreditForWallet(wallet, '4711', function (err, confirmed) {
                            done(err, {walletId: wallet, unconfirmed: unconfirmed, confirmed: confirmed});
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

router.get('/users/:userId/wallets/:walletId', validate({
    query: validation_schema.Empty,
    body: validation_schema.Empty
}), function (req, res, next) {

    const walletId = req.param('walletId');
    vault_service.getCreditForWallet(walletId, '4711', function (err, unconfirmed) {
        if (err) {
            res.status(500).send(err);
        } else {
            vault_service.getConfirmedCreditForWallet(walletId, '4711', function (err, confirmed) {
                res.status(200).send({walletId: walletId, unconfirmed: unconfirmed, confirmed: confirmed});
            });

        }

    });
});

router.post('/users/:userId/wallets/:walletId/payouts', bruteForceProtection.global,
    validate({
        query: validation_schema.Empty,
        body: validation_schema.Payout
    }), function (req, res, next) {
        const userId = req.param('userId');
        const walletId = req.param('walletId');
        const payout = req.body;
        vault_service.getWalletsForUserId(userId, '4711', function (err, wallets) {
            if (err) {
                res.sendStatus(400);
            }
            else if (wallets.indexOf(walletId) === 1) {
                res.status(404).send('The wallet does not exist or does not own this user');
            } else {
                vault_service.payoutCredit(walletId, payout.amount, payout.payoutAddress, '4711', payout.emptyWallet, payout.referenceId, function (err, payout) {
                    if (err) {
                        if (err.statusCode) {
                            res.status(err.statusCode).send(err.message);
                        } else {

                            res.status(500).send(payout);
                        }
                    } else {
                        res.send(payout);
                    }
                });
            }
        });

    });

router.post('/users/:userId/wallets/:walletId/payouts/check',
    bruteForceProtection.global,
    validate({
        query: validation_schema.Empty,
        body: validation_schema.Payout
    }), function (req, res, next) {
        const userId = req.param('userId');
        const walletId = req.param('walletId');
        const payout = req.body;
        vault_service.getWalletsForUserId(userId, '4711', function (err, wallets) {
            if (err) {
                res.sendStatus(400);
            }
            else if (wallets.indexOf(walletId) === 1) {
                res.status(404).send('The wallet does not exist or does not own this user');
            } else {
                vault_service.checkPayout(walletId, payout.amount, payout.payoutAddress, '4711', payout.emptyWallet, payout.referenceId, function (err, payout) {
                    if (err) {
                        if (err.statusCode) {
                            res.status(err.statusCode).send(err.message);
                        } else {

                            res.status(500).send(payout);
                        }
                    } else {
                        res.send(payout);
                    }
                });
            }
        });

    });

module.exports = router;