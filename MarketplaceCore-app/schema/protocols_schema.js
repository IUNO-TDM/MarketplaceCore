const self = {};

self.Empty = {
    type: 'object',
    properties: {},
    additionalProperties: false
};

self.Protocol_Body = {
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

self.Protocol_Query = {
    type: 'object',
    properties: {
        eventType: {
            type: 'string',
            maxLength: 50
        },
        from: {
            type: 'string',
            format: 'date-time'
        },
        to: {
            type: 'string',
            format: 'date-time'
        },
        clientId: {
            type: 'string',
            format: 'uuid'
        },
        limit: {
            type: 'integer'
        }
    },
    additionalProperties: false,
    required: [
        'eventType', 'from', 'to'
    ]
};

self.Protocol_Last_Query = {
    type: 'object',
    properties: {
        eventType: {
            type: 'string',
            maxLength: 50
        },
        from: {
            type: 'string',
            format: 'date-time'
        },
        to: {
            type: 'string',
            format: 'date-time'
        }
    },
    additionalProperties: false,
    required: [
        'eventType', 'from', 'to'
    ]
};

module.exports = self;