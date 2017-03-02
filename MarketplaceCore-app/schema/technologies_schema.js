/* ##########################################################################
 -- Author: Marcel Ely Gomes
 -- Company: Trumpf Werkzeugmaschine GmbH & Co KG
 -- CreatedAt: 2017-02-27
 -- Description: Schema for TechnologyData
 -- ##########################################################################*/

var self = {};

self.Technologies = {
    type: 'object',
    properties: {
        userUUID: {
            type: 'string',
            required: true
        }
    }
};

self.TechnologyByID = {
    type: 'object',
    properties: {
        userUUID: {
            type: 'string',
            required: true
        },
        technologyUUID: {
            type: 'string',
            required: true
        }
    }
};


module.exports = self;