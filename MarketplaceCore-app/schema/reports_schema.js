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
        },
        require: [
            'from',
            'to',
            'detail'
        ]
    },
    additionalProperties: false
};

self.Revenue_User_Query = {
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
        require: [
            'from',
            'to'
        ]
    },
    additionalProperties: false
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
        },
        require: [
            'from',
            'to'
        ],
    },
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
            minimum : 1,
            maximum: 10
        },
        user: {
            type: 'string',
            format: 'uuid'
        },
        require: [
            'from',
            'to',
            'limit',
            'user'
        ],
    },
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
            minimum : 1,
            maximum: 10
        },
        require: [
            'from',
            'to',
            'limit',
            'user'
        ],
    },
    additionalProperties: false
};

self.Empty_Body = {
    type: 'object',
    properties: {},
    additionalProperties: false
};

module.exports = self;