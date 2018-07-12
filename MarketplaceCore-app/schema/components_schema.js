/* ##########################################################################
 -- Author: Marcel Ely Gomes
 -- Company: Trumpf Werkzeugmaschine GmbH & Co KG
 -- CreatedAt: 2017-02-27
 -- Description: Schema for TechnologyData
 -- ##########################################################################*/

const self = {};

self.Empty = {
    type: 'object',
    properties: {},
    additionalProperties: false
};

self.Components_Query = {
    type: 'object',
    properties: {
        technologies: {
            type: 'array',
            minItems: 1,
            maxItems: 10,
            uniqueItems: true,
            items: {
                type: 'string',
                format: 'uuid'
            },
            additionalItems: false
        },
        attributes: {
            type: 'array',
            minItems: 1,
            maxItems: 10,
            uniqueItems: true,
            items: {
                type: 'string',
                format: 'uuid'
            },
            additionalItems: false
        },
        lang: {
            type: 'string',
            enum: ['de','en','fr']
        }
    },
    required: ['technologies', 'lang'],
    additionalProperties: false
};

self.Single_Component_Query = {
    type: 'object',
    properties: {
        lang: {
            type: 'string',
            enum: ['de','en','fr']
        }
    },
    required: ['lang'],
    additionalProperties: false
};

self.SaveData_Body = {
    type: 'object',
    properties: {
        componentName: {
            type: 'string',
            minLength: 1,
            maxLength: 250
        },
        componentParentName: {
            type: 'string',
            minLength: 1,
            maxLength: 250
        },
        componentDescription: {
            type: 'string',
            maxLength: 32672
        },
        attributeList: {
            type: 'array',
            maxItems: 100,
            uniqueItems: true,
            items: {
                type: 'string',
                minLength: 1,
                maxLength: 250
            },
            additionalItems: false
        },
        technologyList: {
            type: 'array',
            minItems: 1,
            maxItems: 10,
            uniqueItems: true,
            items: {
                type: 'string',
                minLength: 1,
                maxLength: 250
            },
            additionalItems: false
        }

    },
    required: ['componentName', 'technologyList'],
    additionalProperties: false
};


module.exports = self;