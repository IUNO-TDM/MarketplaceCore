/* ##########################################################################
 -- Author: Marcel Ely Gomes
 -- Company: Trumpf Werkzeugmaschine GmbH & Co KG
 -- CreatedAt: 2017-02-27
 -- Description: Schema for Components
 -- ##########################################################################*/

var self = {};

self.Components = {
    type: 'object',
    properties: {
        userUUID: {
            type: 'string',
            required: true
        }
    }
};

self.SetComponent = {
    type: 'object',
    properties: {
        userUUID: {
            type: 'string',
            required: true
        },
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


module.exports = self;