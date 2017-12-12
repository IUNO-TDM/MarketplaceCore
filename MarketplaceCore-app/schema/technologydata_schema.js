/* ##########################################################################
 -- Author: Marcel Ely Gomes
 -- Company: Trumpf Werkzeugmaschine GmbH & Co KG
 -- CreatedAt: 2017-02-27
 -- Description: Schema for TechnologyData
 -- ##########################################################################*/

var self = {};

self.Get_Query = {
    anyOf: [
        {
            type: 'object',
            properties: {
                user: {
                    type: 'string',
                    format: 'uuid'
                }
            },
            additionalProperties: false
        },
        {
            type: 'object',
            properties: {
                technology: {
                    type: 'string',
                    format: 'uuid'
                },
                components: {
                    type: 'array',
                    items: {
                        type: 'string',
                        format: 'uuid'
                    },
                    additionalItems: false
                },
                technologydataname: {
                    type: 'string',
                    minLength: 1,
                    maxLength: 250
                },
                ownerUUID: {
                    type: 'string',
                    format: 'uuid'
                }
            },
            additionalProperties: false
        }
    ]
};

self.Empty = {
    type: 'object',
    properties: {},
    additionalProperties: false
};


self.SaveData_Body = {
    type: 'object',
    properties: {
        technologyDataName: {
            type: 'string',
            required: true
        },
        technologyData: {
            type: 'string',
            required: true
        },
        technologyDataDescription: {
            type: 'string',
            required: true
        },
        technologyUUID: {
            type: 'string',
            required: true
        },
        licenseFee: {
            type: 'integer',
            required: true
        },
        tagList: {
            type: 'array',
            items: {
                tagName: {
                    type: 'string',
                    required: true
                }
            }
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
    },
    additionalProperties: false
};

module.exports = self;