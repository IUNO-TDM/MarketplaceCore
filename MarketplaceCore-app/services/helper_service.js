/**
 * Created by beuttlerma on 09.03.16.
 */

String.prototype.format = function () {
    var args = [].slice.call(arguments);
    return this.replace(/(\{\d+\})/g, function (a) {
        return args[+(a.substr(1, a.length - 2)) || 0];
    });
};

var self = {};

self.clone = function clone(a) {
    return JSON.parse(JSON.stringify(a));
};
self.isObject = function isObject(a) {
    return (!!a) && (a.constructor === Object);
};
self.isArray = function isArray(a) {
    return (!!a) && (a.constructor === Array);
};
self.buildFullUrlFromRequest = function (req) {
    return req.protocol + '://' + req.get('host') + req.baseUrl + '/';
};

self.formatString = function (string) {
    var args = [].slice.call(arguments);
    args.shift();
    return string.format(...args);
};


module.exports = self;