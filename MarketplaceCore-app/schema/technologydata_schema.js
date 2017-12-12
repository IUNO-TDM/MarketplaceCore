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
        tags: {
            type: 'array',
            items: {
                type: 'string'
            },
            required: false
        },
        components: {
            type: 'array',
            items: {
                type: 'string'
            },
            required: false
        },
        technologies: {
            type: 'array',
            items: {
                type: 'string'
            },
            required: false
        },
        technologydataname: {
            type: 'string',
            required: false
        },
        attributes: {
            type: 'array',
            items: {
                type: 'string'
            },
            required: false
        },
        ownerUUID: {
            type: 'string',
            required: false
        }
    }
};

self.Empty = {
    type: 'object',
    properties: {

    },
    additionalProperties: false
};


//TODO: Verify this schema
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
    }
};

module.exports = self;