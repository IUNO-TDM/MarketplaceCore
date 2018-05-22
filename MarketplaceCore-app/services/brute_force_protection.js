const ExpressBrute = require('express-brute');
const BruteStore = require('../database/brute_pg/store');
const store = new BruteStore({db: require('../database/db_connection')});

// limit the amount of api calls per user
const global = new ExpressBrute(store, {
    freeRetries: 1000,
    attachResetToRequest: false,
    refreshTimeoutOnRequest: false,
    minWait: 2*60*60*1000, // 2 hour
    maxWait: 2*60*60*1000, // 2 hour
    lifetime: 60*60, // 1 hour (seconds not milliseconds)
});

const protocols = new ExpressBrute(store, {
    freeRetries: 100,
    attachResetToRequest: false,
    refreshTimeoutOnRequest: false,
    minWait: 2*60*60*1000, // 2 hour
    maxWait: 2*60*60*1000, // 2 hour
    lifetime: 60*60, // 1 hour (seconds not milliseconds)
});


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