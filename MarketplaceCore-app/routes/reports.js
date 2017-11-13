/* ##########################################################################
 -- Author: Marcel Ely Gomes
 -- Company: Trumpf Werkzeugmaschine GmbH & Co KG
 -- CreatedAt: 2017-03-08
 -- Description: Routing service for Reports
 -- ##########################################################################*/

const express = require('express');
const router = express.Router();
const logger = require('../global/logger');
const dbReports = require('../database/function/report');
const {Validator, ValidationError} = require('express-json-validator-middleware');
const validator = new Validator({allErrors: true});
const validate = validator.validate;
const validation_schema = require('../schema/reports_schema');

router.get('/revenue/', validate({
    query: validation_schema.Revenue_Query,
    body: validation_schema.Empty_Body
}), function (req, res, next) {
    dbReports.GetTotalRevenue(req.query['from'],
        req.query['to'],
        req.query['detail'],
        req.token.user.id,
        req.token.user.roles, function (err, data) {
            if (err) {
                next(err);
            }
            else {
                res.json(data);
            }
        });
});

router.get('/revenue/user', validate({
    query: validation_schema.Revenue_User_Query,
    body: validation_schema.Empty_Body
}), function (req, res, next) {
    dbReports.GetTotalUserRevenue(
        req.query['from'],
        req.query['to'],
        req.token.user.id,
        req.token.user.roles, function (err, data) {
            if (err) {
                next(err);
            }
            else {
                res.json(data);
            }
        });
});

router.get('/revenue/technologydata/history', validate({
    query: validation_schema.History_Query,
    body: validation_schema.Empty_Body
}), function (req, res, next) {
    dbReports.GetRevenueHistory(
        req.query['from'],
        req.query['to'],
        req.token.user.id,
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

router.get('/technologydata/top', validate({
    query: validation_schema.Top_TD_Query,
    body: validation_schema.Empty_Body
}), function (req, res, next) {
    dbReports.GetTopTechnologyData(
        req.query['from'],
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

router.get('/technologydata/history', validate({
    query: validation_schema.History_Query,
    body: validation_schema.Empty_Body
}), function (req, res, next) {
    dbReports.GetTechnologyDataHistory(
        req.query['from'],
        req.query['to'],
        req.token.user.id,
        req.token.user.roles, function (err, data) {
            if (err) {
                next(err);
            }
            else {
                res.json(data);
            }
        });
});

router.get('/components/top', validate({
    query: validation_schema.Top_Components_Query,
    body: validation_schema.Empty_Body
}), function (req, res, next) {
    dbReports.GetTopComponents(
        req.query['from'],
        req.query['to'],
        req.query['limit'],
        req.token.user.id,
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