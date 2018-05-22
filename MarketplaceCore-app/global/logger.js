/**
 * Created by beuttlerma on 02.12.16.
 *
 * Example usage:
 *  var logger = require('../global/logger');
 *  logger.debug('Foo');
 */
const winston = require('winston');
const _ = require('lodash');
const config = require('../config/config_loader');

// Set up logger
const customColors = {
    trace: 'white',
    debug: 'green',
    info: 'green',
    warn: 'yellow',
    crit: 'red',
    fatal: 'red'
};

const logger = new (winston.Logger)({
    colors: customColors,
    levels: {
        fatal: 1,
        crit: 2,
        warn: 3,
        info: 4,
        debug: 5,
        trace: 6
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

//Logging wrapper, to remove "unknown function" warnings
const origLog = logger.log;
logger.log = function (level, msg) {
    if (!msg) {
        msg = level;
        level = 'info';
    }
    origLog.call(logger, level, msg);
};

const origFatal = logger.fatal;
logger.fatal = function (msg) {
    origFatal.call(logger, msg);
};

const origCrit = logger.crit;
logger.crit = function (msg) {
    origCrit.call(logger, msg);
};

const origWarn = logger.warn;
logger.warn = function (msg) {
    origWarn.call(logger, msg);
};

const origInfo = logger.info;
logger.info = function (msg) {
    origInfo.call(logger, msg);
};

const origDebug = logger.debug;
logger.debug = function (msg) {
    origDebug.call(logger, msg);
};

// Always log the error trace when tracing
const origTrace = logger.trace;
logger.trace = function (msg) {
    const objType = Object.prototype.toString.call(msg);
    if (objType === '[object Error]') {
        origTrace.call(logger, msg);
    } else {
        origTrace.call(logger, new Error(msg));
    }
};


logger.logRequestAndResponse = function (err, options, res, data) {

    const loggerOutput = {};

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
        return new Error(err);
    }
    else if (res && res.statusCode >= 400) {
        logger.warn(loggerOutput);
        let e = new Error(res.statusMessage);
        if (data && data.message) {
            e.message = data.message;
        }
        e.status = res.statusCode;
        return e;
    }
    else {
        logger.debug(loggerOutput);
    }


    return null;
};

module.exports = logger;