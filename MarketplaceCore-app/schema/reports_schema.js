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

self.Revenue_Query = {
    type: 'object',
    properties: {
        from: {
            type: 'string',
            format: 'date-time'
        },
        to: {
            type: 'string',
            format: 'date-time'
        },
        detail: {
            type: 'string',
            enum: ['day', 'hour']
        },
        technologyuuid: {
            type: 'string',
            format: 'uuid'
        }
    },
    required: [
        'from',
        'to',
        'detail',
        'technologyuuid'
    ],
    additionalProperties: false
};

self.Revenue_User_Query = {
    type: 'object',
    properties: {
        user: {
            type: 'string',
            format: 'uuid'
        },
        from: {
            type: 'string',
            format: 'date-time'
        },
        to: {
            type: 'string',
            format: 'date-time'
        },
        technologyuuid: {
            type: 'string',
            format: 'uuid'
        }
    },
    additionalProperties: false,
    required: [
        'from',
        'to',
        'technologyuuid'
    ]
};

self.History_Query = {
    type: 'object',
    properties: {
        from: {
            type: 'string',
            format: 'date-time'
        },
        to: {
            type: 'string',
            format: 'date-time'
        },
        technologyuuid: {
            type: 'string',
            format: 'uuid'
        }
    },
    required: [
        'from',
        'to',
        'technologyuuid'
    ],
    additionalProperties: false
};

self.History_User_Query = {
    type: 'object',
    properties: {
        from: {
            type: 'string',
            format: 'date-time'
        },
        to: {
            type: 'string',
            format: 'date-time'
        },
        technologyuuid: {
            type: 'string',
            format: 'uuid'
        }
    },
    required: [
        'from',
        'to',
        'technologyuuid'
    ],
    additionalProperties: false
};

self.Top_TD_Query = {
    type: 'object',
    properties: {
        from: {
            type: 'string',
            format: 'date-time'
        },
        to: {
            type: 'string',
            format: 'date-time'
        },
        limit: {
            type: 'integer',
            minimum: 1,
            maximum: 10
        },
        user: {
            type: 'string',
            format: 'uuid'
        },
        technologyuuid: {
            type: 'string',
            format: 'uuid'
        }
    },
    required: [
        'from',
        'to',
        'limit',
        'technologyuuid'
    ],
    additionalProperties: false
};

self.Top_Components_Query = {
    type: 'object',
    properties: {
        from: {
            type: 'string',
            format: 'date-time'
        },
        to: {
            type: 'string',
            format: 'date-time'
        },
        limit: {
            type: 'integer',
            minimum: 1,
            maximum: 10
        },
        technologyuuid: {
            type: 'string',
            format: 'uuid'
        },
        lang: languageProperty
    },
    required: [
        'from',
        'to',
        'limit',
        'technologyuuid'
    ],
    additionalProperties: false
};

self.License_Count_Query = {
    type: 'object',
    properties: {
        activated: {
            type: 'boolean'
        },
        user: {
            type: 'string',
            format: 'uuid'
        },
        technologyuuid: {
            type: 'string',
            format: 'uuid'
        }
    },
    required: [
        'activated',
        'user',
        'technologyuuid'
    ],
    additionalProperties: false
};

self.Empty_Body = {
    type: 'object',
    properties: {},
    additionalProperties: false
};

self.Protocol_Body = {
    type: 'object',
    properties: {
        eventType: {
            type: 'string',
            maxLength: 50
        },
        from: {
            type: 'string',
            format: 'date-time'
        },
        to: {
            type: 'string',
            format: 'date-time'
        }
    },
    additionalProperties: false,
    required: [
        'eventType', 'from', 'to'
    ]
};

self.Components_Query = {
    type: 'object',
    properties: {
        lang: languageProperty
    },
    additionalProperties: false
};

module.exports = self;