/**
 * Created by goergch on 12.07.17.
 */


const request = require('request');
const config = require('../config/config_loader');

var logger = require('../global/logger');

var BitcoinVaultService = function () {
    logger.log('a new instance of BitcoinVaultService');
};

const bitcoinVaultService = new BitcoinVaultService();

function buildOptionsForRequest(method, protocol, host, port, path, qs) {

    return {
        method: method,
        url: protocol + '://' + host + ':' + port + path,
        qs: qs,
        json: true,
        headers: {
            'Content-Type': 'application/json'
        }
    }
}

bitcoinVaultService.getWalletsForUserId = function (userId, accessToken, callback) {
    if (typeof(callback) !== 'function') {

        callback = function () {
            logger.info('Callback not registered');
        }
    }

    var options = buildOptionsForRequest(
        'GET',
        config.HOST_SETTINGS.BIT_COIN_VAULT.PROTOCOL || 'http',
        config.HOST_SETTINGS.BIT_COIN_VAULT.HOST || 'localhost',
        config.HOST_SETTINGS.BIT_COIN_VAULT.PORT || 8081,
        '/v1/wallets?userId=' + userId + '&accessToken=' + accessToken
    );

    request(options, function (e, r, jsonData) {
        var err = logger.logRequestAndResponse(e, options, r, jsonData);
        callback(err, jsonData);
    });
};


bitcoinVaultService.createWalletForUserId = function (userId, accessToken, callback) {
    if (typeof(callback) !== 'function') {

        callback = function () {
            logger.info('Callback not registered');
        }
    }

    var options = buildOptionsForRequest(
        'POST',
        config.HOST_SETTINGS.BIT_COIN_VAULT.PROTOCOL || 'http',
        config.HOST_SETTINGS.BIT_COIN_VAULT.HOST || 'localhost',
        config.HOST_SETTINGS.BIT_COIN_VAULT.PORT || 8081,
        '/v1/wallets?accessToken=' + accessToken
    );

    options.body = {
        "userId": userId
    };

    request(options, function (e, r, walletId) {
        var err = logger.logRequestAndResponse(e, options, r, walletId);
        callback(err, walletId);
    });
};

bitcoinVaultService.deleteWallet = function (walletId, accessToken, callback) {
    if (typeof(callback) !== 'function') {

        callback = function () {
            logger.info('Callback not registered');
        }
    }

    var options = buildOptionsForRequest(
        'DELETE',
        config.HOST_SETTINGS.BIT_COIN_VAULT.PROTOCOL || 'http',
        config.HOST_SETTINGS.BIT_COIN_VAULT.HOST || 'localhost',
        config.HOST_SETTINGS.BIT_COIN_VAULT.PORT || 8081,
        '/v1/wallets/' + walletId + '?accessToken=' + accessToken
    );

    request(options, function (e, r, body) {
        var err = logger.logRequestAndResponse(e, options, r, body);
        callback(err, body);
    });
};


bitcoinVaultService.getCreditForWallet = function (walletId, accessToken, callback) {
    if (typeof(callback) !== 'function') {

        callback = function () {
            logger.info('Callback not registered');
        }
    }

    var options = buildOptionsForRequest(
        'GET',
        config.HOST_SETTINGS.BIT_COIN_VAULT.PROTOCOL || 'http',
        config.HOST_SETTINGS.BIT_COIN_VAULT.HOST || 'localhost',
        config.HOST_SETTINGS.BIT_COIN_VAULT.PORT || 8081,
        '/v1/wallets/' + walletId + '/credit?accessToken=' + accessToken
    );

    request(options, function (e, r, credit) {
        var err = logger.logRequestAndResponse(e, options, r, credit);
        callback(err, credit);
    });
};

bitcoinVaultService.getConfirmedCreditForWallet = function (walletId, accessToken, callback) {
    if (typeof(callback) !== 'function') {

        callback = function () {
            logger.info('Callback not registered');
        }
    }

    var options = buildOptionsForRequest(
        'GET',
        config.HOST_SETTINGS.BIT_COIN_VAULT.PROTOCOL || 'http',
        config.HOST_SETTINGS.BIT_COIN_VAULT.HOST || 'localhost',
        config.HOST_SETTINGS.BIT_COIN_VAULT.PORT || 8081,
        '/v1/wallets/' + walletId + '/confirmedcredit?accessToken=' + accessToken
    );

    request(options, function (e, r, credit) {
        var err = logger.logRequestAndResponse(e, options, r, credit);
        callback(err, credit);
    });
};

bitcoinVaultService.getTransactionsForWallet = function (walletId, accessToken, callback) {
    if (typeof(callback) !== 'function') {

        callback = function () {
            logger.info('Callback not registered');
        }
    }

    var options = buildOptionsForRequest(
        'GET',
        config.HOST_SETTINGS.BIT_COIN_VAULT.PROTOCOL || 'http',
        config.HOST_SETTINGS.BIT_COIN_VAULT.HOST || 'localhost',
        config.HOST_SETTINGS.BIT_COIN_VAULT.PORT || 8081,
        '/v1/wallets/' + walletId + '/transactions?accessToken=' + accessToken
    );

    request(options, function (e, r, credit) {
        var err = logger.logRequestAndResponse(e, options, r, credit);
        callback(err, credit);
    });
};

bitcoinVaultService.getNewAddressForWallet = function (walletId, accessToken, callback) {
    if (typeof(callback) !== 'function') {

        callback = function () {
            logger.info('Callback not registered');
        }
    }

    var options = buildOptionsForRequest(
        'GET',
        config.HOST_SETTINGS.BIT_COIN_VAULT.PROTOCOL || 'http',
        config.HOST_SETTINGS.BIT_COIN_VAULT.HOST || 'localhost',
        config.HOST_SETTINGS.BIT_COIN_VAULT.PORT || 8081,
        '/v1/wallets/' + walletId + '/newaddress?accessToken=' + accessToken
    );

    request(options, function (e, r, address) {
        var err = logger.logRequestAndResponse(e, options, r, address);
        callback(err, address);
    });
};


bitcoinVaultService.payoutCredit = function (walletId, amount, address, accessToken, emptyWallet, referenceId, callback) {
    if (typeof(callback) !== 'function') {

        callback = function () {
            logger.info('Callback not registered');
        }
    }

    var options = buildOptionsForRequest(
        'POST',
        config.HOST_SETTINGS.BIT_COIN_VAULT.PROTOCOL || 'http',
        config.HOST_SETTINGS.BIT_COIN_VAULT.HOST || 'localhost',
        config.HOST_SETTINGS.BIT_COIN_VAULT.PORT || 8081,
        '/v1/wallets/' + walletId + '/payouts?accessToken=' + accessToken
    );

    options.body = {
        "payoutId": "",
        "payoutAddress": address,
        "amount": amount,
        "emptyWallet": emptyWallet,
        "referenceId": referenceId
    };

    request(options, function (e, r, payout) {
        var err = logger.logRequestAndResponse(e, options, r, payout);
        callback(err, payout);
    });
};

bitcoinVaultService.checkPayout = function (walletId, amount, address, accessToken, emptyWallet, referenceId, callback) {
    if (typeof(callback) !== 'function') {

        callback = function () {
            logger.info('Callback not registered');
        }
    }

    var options = buildOptionsForRequest(
        'POST',
        config.HOST_SETTINGS.BIT_COIN_VAULT.PROTOCOL || 'http',
        config.HOST_SETTINGS.BIT_COIN_VAULT.HOST || 'localhost',
        config.HOST_SETTINGS.BIT_COIN_VAULT.PORT || 8081,
        '/v1/wallets/' + walletId + '/payouts/check?accessToken=' + accessToken
    );

    options.body = {
        "payoutId": "",
        "payoutAddress": address,
        "amount": amount,
        "emptyWallet": emptyWallet,
        "referenceId": referenceId
    };

    request(options, function (e, r, payout) {
        var err = logger.logRequestAndResponse(e, options, r, payout);
        callback(err, payout);
    });
};

bitcoinVaultService.getPayout = function (walletId, payoutId, accessToken, callback) {
    if (typeof(callback) !== 'function') {

        callback = function () {
            logger.info('Callback not registered');
        }
    }

    var options = buildOptionsForRequest(
        'GET',
        config.HOST_SETTINGS.BIT_COIN_VAULT.PROTOCOL || 'http',
        config.HOST_SETTINGS.BIT_COIN_VAULT.HOST || 'localhost',
        config.HOST_SETTINGS.BIT_COIN_VAULT.PORT || 8081,
        '/v1/wallets/' + walletId + '/payouts/' + payoutId + '?accessToken=' + accessToken
    );

    request(options, function (e, r, payout) {
        var err = logger.logRequestAndResponse(e, options, r, payout);
        callback(err, payout);
    });
};

bitcoinVaultService.getPayoutIds = function (walletId, accessToken, callback) {
    if (typeof(callback) !== 'function') {

        callback = function () {
            logger.info('Callback not registered');
        }
    }

    var options = buildOptionsForRequest(
        'GET',
        config.HOST_SETTINGS.BIT_COIN_VAULT.PROTOCOL || 'http',
        config.HOST_SETTINGS.BIT_COIN_VAULT.HOST || 'localhost',
        config.HOST_SETTINGS.BIT_COIN_VAULT.PORT || 8081,
        '/v1/wallets/' + walletId + '/payouts?accessToken=' + accessToken
    );

    request(options, function (e, r, payoutIds) {
        var err = logger.logRequestAndResponse(e, options, r, payoutIds);
        callback(err, payoutIds);
    });
};


bitcoinVaultService.getPayoutTransactions = function (walletId, payoutId, accessToken, callback) {
    if (typeof(callback) !== 'function') {

        callback = function () {
            logger.info('Callback not registered');
        }
    }

    var options = buildOptionsForRequest(
        'GET',
        config.HOST_SETTINGS.BIT_COIN_VAULT.PROTOCOL || 'http',
        config.HOST_SETTINGS.BIT_COIN_VAULT.HOST || 'localhost',
        config.HOST_SETTINGS.BIT_COIN_VAULT.PORT || 8081,
        '/v1/wallets/' + walletId + '/payouts/' + payoutId + '/transactions?accessToken=' + accessToken
    );

    request(options, function (e, r, payoutTransactions) {
        var err = logger.logRequestAndResponse(e, options, r, payoutTransactions);
        callback(err, payoutTransactions);
    });
};

module.exports = bitcoinVaultService;