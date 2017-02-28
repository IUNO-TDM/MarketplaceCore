/* ##########################################################################
 -- Author: Marcel Ely Gomes
 -- Company: Trumpf Werkzeugmaschine GmbH & Co KG
 -- CreatedAt: 2017-02-27
 -- Description: Schema for TechnologyData
 -- ##########################################################################*/

var self = {};

self.TechnologyData = {
    type: 'object',
    properties: {
        userUUID: {
            type: 'string',
            required: true
        }
    }
};

self.TechnologyDataParameters = {
    type: 'object',
    properties: {
        userUUID: {
            type: 'string',
            required: true
        }
    }
};

self.SetTechnologyData = {
    type: 'object',
    properties: {
        technologyDataName:{
            type: 'string',
            required: true
        },
        technologyData:{
            type: 'string',
            required: true
        },
        technologyDataDescription:{
            type: 'string',
            required: true
        },
        technologyUUID: {
            type: 'string',
            required: false
        },
        licenseFee: {
            type: 'string',
            required: false
        },
        tagList: {
            type: 'array',
            items: {
                tagName: {
                        type: 'string',
                        required: true
                }
            },
            required: true
        },
        userUUID: {
            type: 'string',
            required: true
        },
        componentList: {
            type: 'array',
            items: {
                componentName: {
                    type: 'string',
                    required: true
                }
            },
            required: true
        }
    }
};


module.exports = self;