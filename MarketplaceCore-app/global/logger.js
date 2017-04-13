/**
 * Created by beuttlerma on 02.12.16.
 *
 * Example usage:
 *  var logger = require('../global/logger');
 *  logger.debug('Foo');
 */
var winston = require('winston');
var _ = require('lodash');
var config = require('../global/constants').CONFIG;

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