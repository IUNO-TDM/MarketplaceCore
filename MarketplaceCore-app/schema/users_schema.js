/* ##########################################################################
 -- Author: Marcel Ely Gomes
 -- Company: Trumpf Werkzeugmaschine GmbH & Co KG
 -- CreatedAt: 2017-03-02
 -- Description: Schema for Users
 -- ##########################################################################*/

var self ={};

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
        firstName: {
            type: 'string',
            required: true
        },
        lastName: {
            type: 'string',
            required: true
        },
        emailAddress: {
            type: 'string',
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


module.exports = self;