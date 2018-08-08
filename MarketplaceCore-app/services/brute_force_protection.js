const ExpressBrute = require('express-brute');
const BruteStore = require('../database/brute_pg/store');
const store = new BruteStore({db: require('../database/db_connection')});
const _ = require('lodash');

const logger = require('../global/logger');
const email = require('../services/email_service');

// 1000 Requests per 61 minutes
const global = new ExpressBrute(store, {
    freeRetries: 1000,
    attachResetToRequest: false,
    refreshTimeoutOnRequest: false,
    minWait: 61*60*1000,
    maxWait: 61*60*1000,
    lifetime: 60*60, //(seconds not milliseconds)
    failCallback: failCallback
});

// 150 Requests per 61 minutes
const protocols = new ExpressBrute(store, {
    freeRetries: 150,
    attachResetToRequest: false,
    refreshTimeoutOnRequest: false,
    minWait: 61*60*1000,
    maxWait: 61*60*1000,
    lifetime: 60*60, //(seconds not milliseconds)
    failCallback: failCallback
});

// 2 Request per minute
const fileUpload = new ExpressBrute(store, {
    freeRetries: 1,
    attachResetToRequest: false,
    refreshTimeoutOnRequest: false,
    minWait: 61*1000,
    maxWait: 61*1000,
    lifetime: 60, //(seconds not milliseconds)
    failCallback: failCallback
});



function failCallback (req, res, next, nextValidRequestDate) {

    logger.warn(`[brute_force_protection] Request blocked because of to many attempts`);
    logger.warn(`[brute_force_protection] Path: ${req.baseUrl} - User: ${req.token.user.id} - Client: ${req.token.client.id}`);
    logger.debug(`[brute_force_protection] NextValidRequestDate: ${nextValidRequestDate}`);


    const message = _.pick(req,['baseUrl', 'body', 'method', 'originalUrl','params', 'query', 'token', 'url']);

    email.sendReportToAdmins('Request blocked because of to many attempts', JSON.stringify(message, null, "\t"));

    return ExpressBrute.FailTooManyRequests(req, res, next, nextValidRequestDate);
}

module.exports.global = global.getMiddleware({
    key: function(req, res, next) {
        // prevent too many attempts for the same user
        next(req.token.user.id);
    }
});

module.exports.protocols = protocols.getMiddleware({
    key: function(req, res, next) {
        // prevent too many attempts for the same user
        next(req.token.user.id);
    }
});

module.exports.fileupload = fileUpload.getMiddleware({
    key: function(req, res, next) {
        // prevent too many attempts for the same user
        next(req.token.user.id);
    }
});