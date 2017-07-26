/**
 * Created by goergch on 07.03.17.
 */

const EventEmitter = require('events').EventEmitter;
const util = require('util');
const request = require('request');
const config = require('../config/config_loader');

var Invoice = require('../model/invoice');
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

payment_service.socket = io.connect('http://localhost:8080/invoices', {transports: ['websocket']});

payment_service.socket.on('connect', function () {
    logger.debug("connected to paymentservice");
});

payment_service.socket.on('StateChange', function (invoice) {
    logger.debug("PaymentService StateChange: " + invoice);
    invoice = JSON.parse(invoice);

    if (invoice.state && invoice.state !== 'unknown') {
        // Store state change in database
        var paymentData = {
            transactionUUID: invoice.referenceId,
            extInvoiceId: invoice.invoiceId,
            depth: invoice.depth,
            confidenceState: invoice.state,
            bitcoinTransaction: null,
            userUUID: config.USER_UUID
        };
        dbPayment.SetPayment(config.USER_UUID, paymentData, function (err, payment) {
            if (!err) {
                payment_service.emit('StateChange', {
                    invoice: invoice,
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
        var invoice = new Invoice().CreateFromJSON(jsonData);

        if (!err) {
            payment_service.registerStateChangeUpdates(invoice.invoiceId);
        }

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
    var options = buildOptionsForRequest(
        'GET',
        config.HOST_SETTINGS.PAYMENT_SERVICE.PROTOCOL || 'http',
        config.HOST_SETTINGS.PAYMENT_SERVICE.HOST || 'localhost',
        config.HOST_SETTINGS.PAYMENT_SERVICE.PORT || 8080,
        '/v1/invoices/' + invoice.invoiceId + '/transfers'
    );


    request(options, function (e, r, jsonData) {
        var err = logger.logRequestAndResponse(e, options, r, jsonData);
        var invoice = new Invoice().CreateFromJSON(jsonData);

        callback(err, invoice);
    });
};


payment_service.registerStateChangeUpdates = function (invoiceId) {
    payment_service.socket.emit('room', invoiceId);
};
payment_service.unregisterStateChangeUpdates = function (invoiceId) {
    payment_service.socket.emit('leave', invoiceId);
};

module.exports = payment_service;