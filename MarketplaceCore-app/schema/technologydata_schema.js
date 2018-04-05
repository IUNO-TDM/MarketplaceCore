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
    required: ['technologyDataName', 'technologyData', 'technologyDataDescription', 'technologyUUID', 'componentList'],
    properties: {
        technologyDataName: {
            type: 'string',
            minLength: 1,
            maxLength: 250
        },
        technologyData: {
            oneOf: [
                {
                    type: 'string',
                    pattern: '[A-Za-z0-9+/]*={0,2}$',
                    minLength: 1,
                    maxLength: 100000
                },
                {
                    type: 'string',
                    pattern: '\\{.*\\:\\{.*\\:.*\\}\\}',
                    minLength: 1,
                    maxLength: 100000
                }]
        },
        technologyDataDescription: {
            type: 'string',
            minLength: 1,
            maxLength: 30000
        },
        technologyUUID: {
            type: 'string',
            format: 'uuid'
        },
        licenseFee: {
            type: 'integer',
            maximum: Number.MAX_SAFE_INTEGER
        },
        tagList: {
            type: 'array',
            items: {
                tagName: {
                    type: 'string',
                    minLength: 1,
                    maxLength: 250
                }
            },
            additionalItems: false
        },
        componentList: {
            type: 'array',
            items: {
                componentUUID: {
                    type: 'string',
                    minLength: 1,
                    maxLength: 250
                }
            },
            additionalItems: false
        },
        backgroundColor: {
            type: 'string',
            maxLength: 9,
            pattern: '^#([A-Fa-f0-9]{3}|[A-Fa-f0-9]{4}|[A-Fa-f0-9]{6}|[A-Fa-f0-9]{8})$'
        },
        image: {
            type: 'string',
            maxLength: 10000
        }
    },
    additionalProperties: false
};

module.exports = self;