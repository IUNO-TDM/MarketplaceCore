/* ##########################################################################
 -- Author: Marcel Ely Gomes
 -- Company: Trumpf Werkzeugmaschine GmbH & Co KG
 -- CreatedAt: 2017-02-27
 -- Description: Routing service for TechnologyData
 -- ##########################################################################*/

var express = require('express');
var router = express.Router();
var logger = require('../global/logger');
var validate = require('express-jsonschema').validate;
var queries = require('../connectors/pg-queries');


router.get('/', validate({query: require('../schema/technologydata_schema').GetAll}), function (req, res, next) {
    logger.debug(req);

    if (req.query['name']) {
        //TODO: Merge ByName and ByParams into a single method.
        queries.GetTechnologyDataByName(req.query['userUUID'], req.query['name'], function (err, data) {
            if (err) {
                next(err);
            }
            else {
                res.json([data]);
            }
        });
    }
    else {
        queries.GetTechnologyDataByParams(req.query['userUUID'], req.query, function (err, data) {
            if (err) {
                next(err);
            }
            else {
                res.json(data);
            }
        });
    }
});

router.get('/:id', validate({query: require('../schema/technologydata_schema').GetSingle}), function (req, res, next) {
    logger.debug(req);

    queries.GetTechnologyDataByID(req.query['userUUID'], req.param['id'], function (err, data) {
        if (err) {
            next(err);
        }
        else {
            res.json(data);
        }
    });

});

router.post('/', validate({
    body: require('../schema/technologydata_schema').SaveDataBody,
    query: require('../schema/technologydata_schema').SaveDataQuery
}), function (req, res, next) {
    logger.debug(req);
    queries.saveTechnologyData(req.query['userUUID'], req.body, function(err, data) {
        if (err) {
            next(err);
        }

        var fullUrl = req.protocol + '://' + req.get('host') + req.originalUrl;
        res.set('Location', fullUrl + data.id);
        res.sendStatus(201);
    });
});

module.exports = router;