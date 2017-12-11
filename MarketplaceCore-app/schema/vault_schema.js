var self = {};

self.Empty = {
    type: 'object',
    properties: {},
    additionalProperties: false
};

self.Payout = {
    type: 'object',
    properties: {

        payoutAddress:{
            type: 'string',
            pattern: '[a-zA-Z1-9]{27,35}$',
            required: true
        },
        amount:{
            type: 'integer',
            minimum: 1,
            maximum: 100000000,
            required: true
        },
        emptyWallet:{
            type: 'boolean',
            required: true
        },
        referenceId:{
            type: 'string',
            format: 'alphanumeric',
            required: false

        }
    },
    additionalProperties: false
};

module.exports = self;