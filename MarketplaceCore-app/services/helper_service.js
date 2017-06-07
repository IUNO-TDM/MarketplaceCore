/**
 * Created by beuttlerma on 09.03.16.
 */

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
self.buildFullUrlFromRequest = function(req) {
    return req.protocol + '://' + req.get('host') + req.baseUrl + '/';
};



module.exports = self;