/* ##########################################################################
 -- Author: Marcel Ely Gomes
 -- Company: Trumpf Werkzeugmaschine GmbH & Co KG
 -- CreatedAt: 2017-02-27
 -- Description: Schema for TechnologyData
 -- ##########################################################################*/

var self = {};

self.GetAll = {
    type: 'object',
    properties: {
        userUUID: {
            type: 'string',
            required: true
        }
    }
};

self.GetSingle = {
    type: 'object',
    properties: {
        userUUID: {
            type: 'string',
            required: true
        }
    }
};

self.SaveDataBody = {
    type: 'object',
    properties: {
        technologyName: {
            type: 'string',
            required: true
        },
        technologyDescription: {
            type: 'string',
            required: true
        }
    }
};

self.SaveDataQuery = {
    type: 'object',
    userUUID: {
        type: 'string',
        required: true
    }
};

self.saveTechnologyData = {};


module.exports = self;