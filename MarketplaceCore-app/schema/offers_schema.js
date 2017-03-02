/* ##########################################################################
 -- Author: Marcel Ely Gomes
 -- Company: Trumpf Werkzeugmaschine GmbH & Co KG
 -- CreatedAt: 2017-02-27
 -- Description: Schema for TechnologyData
 -- ##########################################################################*/

var self = {};

self.Offers = {
    type: 'object',
    properties: {
        userUUID: {
            type: 'string',
            required: true
        }
    }
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
                        required: true
                    },
                    amount: {
                        type: 'integer',
                        required: true
                    }
                }
            },
            required: true
        },
        hsmId: {
            type: 'string',
            required: true
        }
    }
};

self.Payment = {
    type: 'object',
    properties: {
        paymentBIP70: {
            type: 'string',
            required: true
        }
    },
    required: true
};

module.exports = self;