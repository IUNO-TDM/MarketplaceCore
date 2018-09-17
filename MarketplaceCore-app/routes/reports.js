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
const dbLicenses = require('../database/function/license');
const {Validator, ValidationError} = require('express-json-validator-middleware');
const validator = new Validator({allErrors: true});
const validate = validator.validate;
const validation_schema = require('../schema/reports_schema');
const reports_helper = require('../services/reports_service');


router.get('/revenue/', validate({
    query: validation_schema.Revenue_Query,
    body: validation_schema.Empty_Body
}), function (req, res, next) {

    const from = req.query['from'];
    const to = req.query['to'];
    const detail = req.query['detail'];
    const technologyuuid = req.query['technologyuuid'];
    dbReports.GetTotalRevenue(
        from, to, technologyuuid, detail,
        req.token.user.id,
        req.token.user.roles, function (err, data) {
            if (err) {
                next(err);
            }
            else {
                if (data.length) {
                    data = reports_helper.fill_gaps_total_revenue(from, to, detail, data);
                }

                res.json(data);
            }
        });
});

router.get('/revenue/user', validate({
    query: validation_schema.Revenue_User_Query,
    body: validation_schema.Empty_Body
}), function (req, res, next) {

    const from = req.query['from'];
    const to = req.query['to'];
    const technologyuuid = req.query['technologyuuid'];
    const userid = req.token.user.id;
    const userroles = req.token.user.roles;

    dbReports.GetTotalUserRevenue(
        from,
        to,
        technologyuuid,
        userid,
        userroles, function (err, data) {
            if (err) {
                next(err);
            }
            else {
                res.json(data);
            }
        });
});


router.get('/revenue/technologydata/history', validate({
    query: validation_schema.History_User_Query,
    body: validation_schema.Empty_Body
}), function (req, res, next) {

    const from = req.query['from'];
    const to = req.query['to'];
    const technologyuuid = req.query['technologyuuid'];
    const userid = req.token.user.id;
    const userroles = req.token.user.roles;
    dbReports.GetRevenueHistory(
        from,
        to,
        technologyuuid,
        userid,
        userroles,
        function (err, data) {
            if (err) {
                next(err);
            }
            else {

                if (data.length) {
                    data = reports_helper.fill_gaps_revenue_history(from, to, data);
                }
                res.json(data);

            }
        });
});

router.get('/technologydata/top', validate({
    query: validation_schema.Top_TD_Query,
    body: validation_schema.Empty_Body
}), function (req, res, next) {

    const from = req.query['from'];
    const to = req.query['to'];
    const technologyuuid = req.query['technologyuuid'];
    const limit = req.query['limit'];
    const userid = req.query['user'];
    const userroles = req.token.user.roles;

    dbReports.GetTopTechnologyData(
        from,
        to,
        technologyuuid,
        limit,
        userid,
        userroles, function (err, data) {
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

    const from = req.query['from'];
    const to = req.query['to'];
    const technologyuuid = req.query['technologyuuid'];
    const userid = req.token.user.id;
    const userroles = req.token.user.roles;

    dbReports.GetTechnologyDataHistory(
        from,
        to,
        technologyuuid,
        userid,
        userroles, function (err, data) {
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

    const from = req.query['from'];
    const to = req.query['to'];
    const technologyuuid = req.query['technologyuuid'];
    const limit = req.query['limit'];
    const lang = req.query['lang'];
    const userid = req.token.user.id;
    const userroles = req.token.user.roles;

    dbReports.GetTopComponents(
        from,
        to,
        technologyuuid,
        limit,
        userid,
        lang,
        userroles, function (err, data) {
            if (err) {
                next(err);
            }
            else {
                res.json(data);
            }
        });
});

router.get('/licenses/count', validate({
    query: validation_schema.License_Count_Query,
    body: validation_schema.Empty_Body
}), function (req, res, next) {
    if (req.query['activated']) {

        const technologyuuid = req.query['technologyuuid'];
        const userid = req.query['user'];
        const inquirer = req.token.user;

        dbLicenses.GetActivatedLicenseCountForUser(
            technologyuuid,
            userid,
            inquirer, function (err, data) {
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