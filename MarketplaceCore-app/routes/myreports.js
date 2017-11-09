/* ##########################################################################
 -- Author: Marcel Ely Gomes
 -- Company: Trumpf Werkzeugmaschine GmbH & Co KG
 -- CreatedAt: 2017-03-08
 -- Description: Routing service for Reports
 -- ##########################################################################*/

var express = require('express');
var router = express.Router();
var logger = require('../global/logger');
var dbReports = require('../database/function/myreport');

router.get('/technologydata/', function (req, res, next) {
    if(!req.query['top']) {
        dbReports.GetTechnologyDataForUser(req.query['userUUID'], req.token.user.roles, function (err, data) {
            if (err) {
                next(err);
            }

            else {
                //logger.debug('TechDataResponse: ' + JSON.stringify(data));
                res.json(data);
            }
        });
    }
    else {
        dbReports.GetTopTechnologyDataForUser(req.query['userUUID'], req.token.user.roles, req.query['topValue'], function (err, data) {
            if (err) {
                next(err);
            }

            else {
                res.json(data);
            }
        });
    }
});

module.exports = router;