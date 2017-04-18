/**
 * Created by beuttlerma on 02.12.16.
 *
 * Example usage:
 *  var logger = require('../global/logger');
 *  logger.debug('Foo');
 */
var winston = require('winston');
var _ = require('lodash');
var config = require('../config/config_loader').loadConfig();

// Set up logger
var customColors = {
    trace: 'white',
    debug: 'green',
    info: 'green',
    warn: 'yellow',
    crit: 'red',
    fatal: 'red'
};

var logger = new (winston.Logger)({
    colors: customColors,
    levels: {
        fatal: 0,
        crit: 1,
        warn: 2,
        info: 3,
        debug: 4,
        trace: 5
    },
    transports: [
        new (winston.transports.Console)({
            level: config.LOG_LEVEL,
            colorize: true,
            timestamp: true
        })
        // new (winston.transports.File)({ filename: 'somefile.log' })
    ]
});

winston.addColors(customColors);

// Extend logger object to properly log 'Error' types
var origLog = logger.log;
logger.log = function (level, msg) {
    if (!msg) {
        msg = level;
        level = 'info';
    }
    var objType = Object.prototype.toString.call(msg);
    if (objType === '[object Error]') {
        origLog.call(logger, level, msg.toString());
    } else {
        origLog.call(logger, level, msg);
    }
};

var origFatal = logger.fatal;
logger.fatal = function (msg) {
    var objType = Object.prototype.toString.call(msg);
    if (objType === '[object Error]') {
        origFatal.call(logger, msg.toString());
    } else {
        origFatal.call(logger, msg);
    }
};

var origCrit = logger.crit;
logger.crit = function (msg) {
    var objType = Object.prototype.toString.call(msg);
    if (objType === '[object Error]') {
        origCrit.call(logger, msg.toString());
    } else {
        origCrit.call(logger, msg);
    }
};

var origWarn = logger.warn;
logger.warn = function (msg) {
    var objType = Object.prototype.toString.call(msg);
    if (objType === '[object Error]') {
        origWarn.call(logger, msg.toString());
    } else {
        origWarn.call(logger, msg);
    }
};

var origInfo = logger.info;
logger.info = function (msg) {
    var objType = Object.prototype.toString.call(msg);
    if (objType === '[object Error]') {
        origInfo.call(logger, msg.toString());
    } else {
        origInfo.call(logger, msg);
    }
};

var origDebug = logger.debug;
logger.debug = function (msg) {
    var objType = Object.prototype.toString.call(msg);
    if (objType === '[object Error]') {
        origDebug.call(logger, msg.toString());
    } else {
        origDebug.call(logger, msg);
    }
};

var origTrace = logger.trace;
logger.trace = function (msg) {
    var objType = Object.prototype.toString.call(msg);
    if (objType === '[object Error]') {
        origTrace.call(logger, msg.toString());
    } else {
        origTrace.call(logger, msg);
    }
};

logger.logRequestAndResponse = function (err, options, res, data) {

    var loggerOutput = {};

    if (options) {
        loggerOutput.options = options;
    }

    if (res) {
        loggerOutput.statusCode = res.statusCode;
        loggerOutput.statusMessage = res.statusMessage;
    }

    if (data) {
        loggerOutput.data = data;
    }

    if (err) {
        loggerOutput.err = err;
        logger.crit(loggerOutput);
        return new Error(loggerOutput);
    }
    else if (res && res.statusCode > 201) {
        logger.warn(loggerOutput);
        return new Error(loggerOutput);
    }
    else {
        logger.debug(loggerOutput);
    }


    return null;
};

module.exports = logger;