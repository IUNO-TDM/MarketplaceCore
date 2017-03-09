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
        componentName: {
            type: 'string',
            required: true
        },
        componentParentName: {
            type: 'string',
            required: true
        },
        componentDescription: {
            type: 'string',
            required: true
        },
        attributeList: {
            type: 'array',
            required: true
        },
        technologyList: {
            type: 'array',
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