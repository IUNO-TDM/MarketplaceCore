/* ##########################################################################
 -- Author: Marcel Ely Gomes
 -- Company: Trumpf Werkzeugmaschine GmbH & Co KG
 -- CreatedAt: 2017-02-27
 -- Description: Schema for TechnologyData
 -- ##########################################################################*/

var self = {};

self.Empty = {
    type: 'object',
    properties: {},
    additionalProperties: false
};

self.OfferRequestBody = {
    type: 'object',
    properties: {
        items: {
            type: 'array',
            items: {
                type: 'object',
                properties: {
                    dataId: {
                        type: 'string',
                        format: 'uuid'
                    },
                    amount: {
                        type: 'integer',
                        minimum : 1,
                        maximum: 100
                    },
                    required: ['dataId', 'amount']
                },
                additionalProperties: false
            }
        },
        hsmId: {
            type: 'string',
            pattern: '[3-9]-[0-9]{7}$'
        }
    },
    required: ['items', 'hsmId'],
    additionalProperties: false
};

module.exports = self;