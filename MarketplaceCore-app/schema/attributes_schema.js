/* ##########################################################################
 -- Author: Marcel Ely Gomes
 -- Company: Trumpf Werkzeugmaschine GmbH & Co KG
 -- CreatedAt: 2017-02-27
 -- Description: Schema for TechnologyData
 -- ##########################################################################*/

var self = {};

self.Attributes = {
    type: 'object',
    properties: {
        userUUID: {
            type: 'string',
            required: true
        }
    }
};

self.CreateAttribute = {
    type: 'object',
    properties: {
        userUUID: {
            type: 'string',
            required: true
        },
        attributeName: {
            type: 'string',
            required: true
        }
    }
};


module.exports = self;