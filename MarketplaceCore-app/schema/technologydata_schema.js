/* ##########################################################################
 -- Author: Marcel Ely Gomes
 -- Company: Trumpf Werkzeugmaschine GmbH & Co KG
 -- CreatedAt: 2017-02-27
 -- Description: Schema for TechnologyData
 -- ##########################################################################*/

const self = {};

const languageProperty = {
    type: 'string',
    enum: ['de', 'en']
};

self.Get_Query = {
    anyOf: [
        {
            type: 'object',
            properties: {
                user: {
                    type: 'string',
                    format: 'uuid'
                },
                lang: languageProperty
            },
            additionalProperties: false,
            required:['lang']
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
                },
                productCodes: {
                    type: 'array',
                    minItems: 1,
                    maxItems: 100,
                    uniqueItems: true,
                    items: {
                        type: 'integer',
                        minimum: 1000,
                        maximum: 1000000
                    },
                    additionalItems: false
                },
                lang: languageProperty
            },
            additionalProperties: false,
            required:['lang']
        },
        {
            type: 'object',
            properties: {
                lang: languageProperty
            },
            additionalProperties: false,
            required:['lang']
        }
    ]
};

self.Empty = {
    type: 'object',
    properties: {},
    additionalProperties: false
};

self.Components_Query = {
    type: 'object',
    properties: {
        lang: languageProperty
    },
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
                    pattern: '^(?:[A-Za-z0-9+/]{4})*(?:[A-Za-z0-9+/]{2}==|[A-Za-z0-9+/]{3}=)?$',
                    minLength: 1,
                    maxLength: 100000
                },
                {
                    type: 'string',
                    pattern: '\\{.*\\:\\{.*\\:.*\\}\\}',
                    minLength: 1,
                    maxLength: 100000
                },
                {
                    type: 'string',
                    format: 'uuid'
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

self.GetContent_Query = {
    type: 'object',
    properties: {
        offerId: {
            type: 'string',
            format: 'uuid'
        }
    },
    required: ['offerId'],
    additionalProperties: false
};
module.exports = self;