/* ##########################################################################
 -- Author: Marcel Ely Gomes
 -- Company: Trumpf Werkzeugmaschine GmbH & Co KG
 -- CreatedAt: 2017-02-27
 -- Description: Schema for TechnologyData
 -- ##########################################################################*/

var self = {};

self.Empty_Query = {
    type: 'object',
    properties: {

    },
    additionalProperties: false
};

self.Empty_Body = {
    type: 'object',
    properties: {

    },
    additionalProperties: false
};

self.SaveDataBody = {
    type: 'object',
    properties: {
        componentName: {
            type: 'string'
        },
        componentParentName: {
            type: 'string'
        },
        componentDescription: {
            type: 'string'
        },
        attributeList: {
            type: 'array'
        },
        technologyList: {
            type: 'array'
        },
        required: [ 'componentName', 'componentParentName', 'componentDescription', 'attributeList', 'technologyList']
    },
    additionalProperties: false
};


module.exports = self;