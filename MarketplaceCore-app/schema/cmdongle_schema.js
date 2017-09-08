/* ##########################################################################
 -- Author: Marcel Ely Gomes
 -- Company: Trumpf Werkzeugmaschine GmbH & Co KG
 -- CreatedAt: 2017-02-27
 -- Description: Schema for TechnologyData
 -- ##########################################################################*/

const self = {};

self.LicenseUpdate_Body = {
    type: 'object',
    properties: {
        RAC: {
            type: 'string',
            format: 'byte',
            required: true
        }
    }
};

self.LicenseUpdate_Query = {
    type: 'object',
    properties: {}
};

module.exports = self;