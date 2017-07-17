/**
 * Created by beuttlerma on 11.07.17.
 */

var self = {};

self.AccessToken = {
    type: 'object',
    properties: {
        userUUID: {
            type: 'string',
            required: true
        }
    }
};

module.exports = self;