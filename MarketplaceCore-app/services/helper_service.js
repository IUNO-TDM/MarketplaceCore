/**
 * Created by beuttlerma on 09.03.16.
 */

const ascii85 = require('ascii85');

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
    let args = [].slice.call(arguments);
    args.shift();
    return string.format(...args);
};

self.convertUUIDtoBase64 = function (uuid) {

    uuid = uuid.replace(new RegExp('-', 'g'), '');
    let base64 = new Buffer(uuid, 'hex').toString('base64');

    base64 = base64.replace(/\+/g, '-').replace(/\//g, '_').replace(/=+$/, '');

    return base64;
};

self.convertUUIDtoBase85 = function (uuid) {

    uuid = uuid.replace(new RegExp('-', 'g'), '');
    const base85String = ascii85.encode(new Buffer(uuid, 'hex')).toString();

    if (base85String.length > 20) {
        throw new Error('[helper_service] Error when encoding uuid. Resulting string is to long.')
    }

    return base85String;
};


module.exports = self;