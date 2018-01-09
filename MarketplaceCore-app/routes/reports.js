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
const moment = require('moment');
router.get('/revenue/', validate({
    query: validation_schema.Revenue_Query,
    body: validation_schema.Empty_Body
}), function (req, res, next) {
    dbReports.GetTotalRevenue(
        req.query['from'],
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
    query: validation_schema.History_User_Query,
    body: validation_schema.Empty_Body
}), function (req, res, next) {

    var from = req.query['from'];
    var to = req.query['to'];
    dbReports.GetRevenueHistory(
        from,
        to,
        req.token.user.id,
        req.token.user.roles,
        function (err, data) {
            if (err) {
                next(err);
            }
            else {
                if (!data.length) {
                    res.json(data);
                } else {
                    console.log(moment().format());
                    const startDate = moment.utc(from);
                    const endDate = moment.utc(to);

                    var dates = [];
                    var date = startDate.startOf('day');
                    do {
                        dates.push(date.toDate());
                        date.add(1, 'day');
                    } while (date.isBefore(endDate));


                    var no_gap_data = {};
                    for (var i in data) {
                        if (!no_gap_data[(data[i].technologydataname)]) {
                            no_gap_data[data[i].technologydataname] = [];

                            for (var j in dates) {
                                no_gap_data[data[i].technologydataname].push({
                                    date: dates[j],
                                    revenue: "0",
                                    technologydataname: data[i].technologydataname
                                });
                            }
                        }
                        var date = data[i].date;
                        var d = moment.utc([date.getFullYear(), date.getMonth(), date.getDate()]);
                        var d2 = d.toDate();
                        function indexOfDate(element){
                            return (element.getTime() == d2.getTime());
                        }

                        var k = dates.findIndex(indexOfDate);
                        no_gap_data[data[i].technologydataname][k].revenue = data[i].revenue;
                    }

                    var returnvalue = [];
                    for (var i in no_gap_data){
                        returnvalue = returnvalue.concat(no_gap_data[i]);
                    }
                    res.send(returnvalue);
                }


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

router.get('/licenses/count', validate({
    query: validation_schema.License_Count_Query,
    body: validation_schema.Empty_Body
}), function (req, res, next) {
    if (req.query['activated']) {
        dbLicenses.GetActivatedLicenseCountForUser(
            req.query['user'],
            req.token.user, function (err, data) {
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