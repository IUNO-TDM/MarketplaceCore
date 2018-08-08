/**
 * Created by goergch on 07.03.17.
 */

const EventEmitter = require('events').EventEmitter;
const util = require('util');
const request = require('request');
const config = require('../config/config_loader');
const helper = require('../services/helper_service');

var Invoice = require('../model/invoice');
var Transfer = require('../model/transfer');
var logger = require('../global/logger');
var io = require('socket.io-client');
var dbPayment = require('../database/function/payment');

var PaymentService = function () {
    logger.log('a new instance of PaymentService');

};

const payment_service = new PaymentService();
util.inherits(PaymentService, EventEmitter);

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

payment_service.socket = io.connect(helper.formatString(
    '{0}://{1}:{2}/invoices',
    config.HOST_SETTINGS.PAYMENT_SERVICE.PROTOCOL,
    config.HOST_SETTINGS.PAYMENT_SERVICE.HOST,
    config.HOST_SETTINGS.PAYMENT_SERVICE.PORT
), {transports: ['websocket']});

payment_service.socket.on('connect', function () {
    logger.debug("connected to paymentservice");
});

payment_service.socket.on('PaymentStateChange', function (data) {
    logger.debug("PaymentService StateChange: " + data);
    const paymentStateChange = JSON.parse(data);

    if (paymentStateChange.state === 'pending' || paymentStateChange.state === 'building') {
        // Store state change in database
        const paymentData = {
            transactionUUID: paymentStateChange.referenceId,
            extInvoiceId: paymentStateChange.invoiceId,
            depth: paymentStateChange.depthInBlocks,
            confidenceState: paymentStateChange.state,
            bitcoinTransaction: null
        };
        dbPayment.SetPayment(config.USER, paymentData, function (err, payment) {
            if (!err) {
                payment_service.emit('StateChange', {
                    invoice: paymentStateChange,
                    payment: payment
                });
            }
        });
    }
});


payment_service.socket.on('disconnect', function () {
    logger.debug("disconnect");
});

payment_service.createLocalInvoice = function (invoice, callback) {
    if (typeof(callback) !== 'function') {

        callback = function () {
            logger.info('Callback not registered');
        }
    }

    var options = buildOptionsForRequest(
        'POST',
        config.HOST_SETTINGS.PAYMENT_SERVICE.PROTOCOL || 'http',
        config.HOST_SETTINGS.PAYMENT_SERVICE.HOST || 'localhost',
        config.HOST_SETTINGS.PAYMENT_SERVICE.PORT || 8080,
        '/v1/invoices'
    );
    options.body = invoice;

    request(options, function (e, r, jsonData) {
        var err = logger.logRequestAndResponse(e, options, r, jsonData);


        if (err) {
            logger.crit('[payment_service] error while creating local invoice');
            return callback(err);
        }

        var invoice = new Invoice().CreateFromJSON(jsonData);

        payment_service.registerStateChangeUpdates(invoice.invoiceId);
        callback(err, invoice);
    });
}
;

payment_service.getInvoiceTransfers = function (invoice, callback) {
    if (typeof(callback) !== 'function') {

        callback = function () {
            logger.info('Callback not registered');
        }
    }
    try {
        var options = buildOptionsForRequest(
            'GET',
            config.HOST_SETTINGS.PAYMENT_SERVICE.PROTOCOL || 'http',
            config.HOST_SETTINGS.PAYMENT_SERVICE.HOST || 'localhost',
            config.HOST_SETTINGS.PAYMENT_SERVICE.PORT || 8080,
            '/v1/invoices/' + invoice.invoiceId + '/transfers'
        );


        request(options, function (e, r, jsonData) {
            var err = logger.logRequestAndResponse(e, options, r, jsonData);
            var transfers = Transfer.CreateListFromJSON(jsonData);

            callback(err, transfers);
        });
    }
    catch (err) {
        logger.crit(err);
        callback(err);
    }

};

payment_service.getInvoiceBip21 = function (invoice, callback) {
    if (typeof(callback) !== 'function') {

        callback = function () {
            logger.info('Callback not registered');
        }
    }
    try {
        const options = buildOptionsForRequest(
            'GET',
            config.HOST_SETTINGS.PAYMENT_SERVICE.PROTOCOL || 'http',
            config.HOST_SETTINGS.PAYMENT_SERVICE.HOST || 'localhost',
            config.HOST_SETTINGS.PAYMENT_SERVICE.PORT || 8080,
            `/v1/invoices/${invoice.invoiceId}/bip21`
        );


        request(options, function (e, r, jsonData) {
            const err = logger.logRequestAndResponse(e, options, r, jsonData);

            callback(err, jsonData);
        });
    }
    catch (err) {
        logger.crit(err);
        callback(err);
    }
};


payment_service.registerStateChangeUpdates = function (invoiceId) {
    payment_service.socket.emit('room', invoiceId);
};
payment_service.unregisterStateChangeUpdates = function (invoiceId) {
    payment_service.socket.emit('leave', invoiceId);
};

module.exports = payment_service;
