/* ##########################################################################
 -- Author: Marcel Ely Gomes
 -- Company: Trumpf Werkzeugmaschine GmbH & Co KG
 -- CreatedAt: 2017-03-08
 -- Description: Routing service for Reports
 -- ##########################################################################*/

var express = require('express');
var router = express.Router();
var logger = require('../global/logger');
var dbReports = require('../database/function/report');

router.get('/revenue/', function (req, res, next) {
    dbReports.GetTotalRevenue(req.query['from'],
                         req.query['to'],
                         req.query['detail'],
                         req.query['userUUID'],
                         req.token.user.roles, function (err, data) {
        if (err) {
            next(err);
        }
        else {
            res.json(data);
        }
    });
});

router.get('/revenue/user', function (req, res, next) {
    dbReports.GetTotalUserRevenue(req.query['from'],
        req.query['to'],
        req.query['detail'],
        req.query['userUUID'],
        req.token.user.roles, function (err, data) {
            if (err) {
                next(err);
            }
            else {
                res.json(data);
            }
        });
});

router.get('/revenue/technologydata/history', function (req, res, next) {
        dbReports.GetRevenueHistory(req.query['from'],
                                    req.query['to'],
                                    req.query['technologydataname'],
                                    req.query['detail'],
                                    req.query['userUUID'],
                                    req.token.user.roles,
                                    function (err, data) {
            if (err) {
                next(err);
            }
            else {
                res.json(data);
            }
        });
});

router.get('/technologydata/top', function (req, res, next) {
    dbReports.GetTopTechnologyData( req.query['from'],
                                    req.query['to'],
                                    req.query['limit'],
                                    req.query['user'],
                                    req.token.user.roles, function (err, data) {
        if (err) {
            next(err);
        }
        else {
            res.json(data);
        }
    });
});

router.get('/technologydata/history', function (req, res, next) {
    dbReports.GetTechnologyDataHistory( req.query['from'],
                                        req.query['to'],
                                        req.query['detail'],
                                        req.query['userUUID'],
                                        req.token.user.roles, function (err, data) {
            if (err) {
                next(err);
            }
            else {
                res.json(data);
            }
        });
});

router.get('/components/top', function (req, res, next) {
    dbReports.GetTopComponents( req.query['from'],
                                req.query['to'],
                                req.query['limit'],
                                req.query['userUUID'],
                                req.token.user.roles, function (err, data) {
            if (err) {
                next(err);
            }
            else {
                res.json(data);
            }
        });
});

module.exports = router;