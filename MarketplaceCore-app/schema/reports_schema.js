/* ##########################################################################
 -- Author: Marcel Ely Gomes
 -- Company: Trumpf Werkzeugmaschine GmbH & Co KG
 -- CreatedAt: 2017-02-27
 -- Description: Schema for TechnologyData
 -- ##########################################################################*/

const self = {};

self.Revenue_Query = {
    type: 'object',
    properties: {
        from: {
            type: 'string',
            format: 'date-time'
        },
        to: {
            type: 'string',
            format: 'date-time'
        },
        detail: {
            type: 'string',
            enum: ['day', 'hour']
        }
    },
    required: [
        'from',
        'to',
        'detail'
    ],
    additionalProperties: false
};

self.Revenue_User_Query = {
    type: 'object',
    properties: {
        user: {
            type: 'string',
            format: 'uuid'
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
        'from',
        'to'
    ]
};

self.History_Query = {
    type: 'object',
    properties: {
        from: {
            type: 'string',
            format: 'date-time'
        },
        to: {
            type: 'string',
            format: 'date-time'
        }
    },
    required: [
        'from',
        'to'
    ],
    additionalProperties: false
};

self.History_User_Query = {
    type: 'object',
    properties: {
        from: {
            type: 'string',
            format: 'date-time'
        },
        to: {
            type: 'string',
            format: 'date-time'
        }
    },
    required: [
        'from',
        'to'
    ],
    additionalProperties: false
};

self.Top_TD_Query = {
    type: 'object',
    properties: {
        from: {
            type: 'string',
            format: 'date-time'
        },
        to: {
            type: 'string',
            format: 'date-time'
        },
        limit: {
            type: 'integer',
            minimum: 1,
            maximum: 10
        },
        user: {
            type: 'string',
            format: 'uuid'
        }
    },
    required: [
        'from',
        'to',
        'limit'
    ],
    additionalProperties: false
};

self.Top_Components_Query = {
    type: 'object',
    properties: {
        from: {
            type: 'string',
            format: 'date-time'
        },
        to: {
            type: 'string',
            format: 'date-time'
        },
        limit: {
            type: 'integer',
            minimum: 1,
            maximum: 10
        }
    },
    required: [
        'from',
        'to',
        'limit'
    ],
    additionalProperties: false
};

self.Empty_Body = {
    type: 'object',
    properties: {},
    additionalProperties: false
};

module.exports = self;