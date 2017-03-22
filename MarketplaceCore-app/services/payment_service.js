/**
 * Created by goergch on 07.03.17.
 */

const EventEmitter = require('events').EventEmitter;
const util = require('util');
const http = require('http');
const config = require('../global/constants').CONFIG;

var logger = require('../global/logger');
var io = require('socket.io-client');
var queries = require('../connectors/pg-queries');

var PaymentService = function () {
    logger.log('a new instance of PaymentService');

};

const payment_service = new PaymentService();
util.inherits(PaymentService, EventEmitter);


payment_service.socket = io.connect('http://localhost:8080/invoices', {transports: ['websocket']});

payment_service.socket.on('connect', function () {
    logger.debug("connected to paymentservice");
});

payment_service.socket.on('StateChange', function (invoice) {
    logger.debug("PaymentService StateChange: " + invoice);
    invoice = JSON.parse(invoice);

    if (invoice.state && invoice.state != 'unknown') {
        // Store state change in database
        var paymentData = {
            transactionUUID: invoice.referenceId,
            extInvoiceId: invoice.invoiceId,
            depth: invoice.depth,
            confidenceState: invoice.state,
            bitcoinTransaction: null,
            userUUID: config.USER_UUID
        };
        queries.SetPayment(config.USER_UUID, paymentData, function (err, payment) {
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
    var body = JSON.stringify(invoice);
    var options = {
        hostname: 'localhost',
        port: 8080,
        path: '/v1/invoices/',
        agent: false,
        method: 'POST',
        headers: {
            'Content-Type': 'application/json'
        }
    };
    var req = http.request(options, function (res) {
            logger.log("Got answer from PS for CreateLocalInvoice:" + res.statusCode + ' ' + res.statusMessage);
            res.on('data', function (data) {
                if (res.statusCode > 201) {
                    logger.warn('CreateLocalInvoice: Call not successful. Response: + ' + data);
                }

                var invoice = JSON.parse(data);
                payment_service.registerStateChangeUpdates(invoice.invoiceId);
                callback(null, invoice);
            });
        }
    ).end(body);
};

payment_service.getInvoiceTransfers = function (invoice, callback) {
    var options = {
        hostname: 'localhost',
        port: 8080,
        path: '/v1/invoices/' + invoice.invoiceId + '/transfers',
        agent: false,
        method: 'GET'
    };
    var req = http.request(options, function (res) {
            logger.log("Got answer from PS for GetInvoiceTransfer:" + res.statusCode + ' ' + res.statusMessage);
            res.on('data', function (data) {
                if (res.statusCode > 201) {
                    logger.warn('GetInvoiceTransfers: Call not successful. Response: + ' + data);
                }

                var transfers = JSON.parse(data.toString());
                callback(null, transfers);
            });
        }
    ).end();
};


payment_service.registerStateChangeUpdates = function (invoiceId) {
    payment_service.socket.emit('room', invoiceId);
};
payment_service.unregisterStateChangeUpdates = function (invoiceId) {
    payment_service.socket.emit('leave', invoiceId);
};

module.exports = payment_service;