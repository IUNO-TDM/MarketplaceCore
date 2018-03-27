var self = {};

self.Empty = {
    type: 'object',
    properties: {},
    additionalProperties: false
};

self.Protocol = {
    type: 'object',
    properties: {
        eventType: {
            type: 'string',
            maxLength: 50
        },
        timestamp: {
            type: 'string',
            format: 'date-time'
        },
        payload: {
            type: 'object',
            properties: {},
            additionalProperties: true
        }
    },
    additionalProperties: false,
    required: [
        'eventType', 'timestamp', 'payload'
    ]
};


module.exports = self;