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
        },
        name: {
            type: 'string',
            required: false
        },
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
        attributes: {
            type: 'array',
            items: {
                type: 'string'
            },
            required: false
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

self.SaveDataQuery = {
    type: 'object',
    userUUID: {
        type: 'string',
        required: true
    }
};

self.saveTechnologyData = {};


module.exports = self;