/* ##########################################################################
 -- Author: Marcel Ely Gomes
 -- Company: Trumpf Werkzeugmaschine GmbH & Co KG
 -- CreatedAt: 2017-02-27
 -- Description: Schema for TechnologyData
 -- ##########################################################################*/

var Technologies = {
    type: 'object',
    properties: {
        userUUID: {
            type: 'string',
            required: true
        }
    }
};

var TechnologyByID = {
    type: 'object',
    properties: {
        userUUID: {
            type: 'string',
            required: true
        },
        technologyUUID: {
            type: 'string',
            required: true
        }
    }
};


module.exports = {Technologies, TechnologyByID};