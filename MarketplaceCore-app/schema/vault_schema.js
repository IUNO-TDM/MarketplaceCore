var self = {};

self.Empty = {
    type: 'object',
    properties: {},
    additionalProperties: false
};

self.Payout = {
    type: 'object',
    properties: {
        payoutId:{
            type: 'string',
            format: 'uuid'
        },
        payoutAddress:{
            type: 'string',
            pattern: '[a-zA-Z1-9]{27,35}$'
        },
        amount:{
            type: 'integer',
            minimum: 1,
            maximum: 100000000
        },
        emptyWallet:{
            type: 'boolean'
        },
        referenceId:{
            type: 'string',
            maxLength: 50

        }
    },
    additionalProperties: false,
    required: [
        'amount', 'payoutAddress', 'emptyWallet'
    ]
};

module.exports = self;