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


router.get('/', validate({query: require('../schema/technologies_schema').GetAll}), function (req, res, next) {

    if(req.query['technologyName']) {
        queries.GetTechnologyByName(req.query['userUUID'], req.query['technologyName'], function (err, data) {
            if (err) {
                next(err);
            }
            else {
                res.json(data);
            }
        });
    }
    else {
        queries.GetAllTechnologies(req.query['userUUID'], function(err,data) {
            if (err) {
                next(err);
            }
            else {
                res.json(data);
            }
        });
    }
});

router.get('/:id', validate({query: require('../schema/technologies_schema').GetSingle}),  function (req, res, next) {
    logger.debug(req);
    queries.GetTechnologyByID(req.query['userUUID'], req.params['id'], function (err, data) {
        if (err) {
            next(err);
        }
        else {
            res.json(data);
        }
    });
});

router.post('/', validate({
    body: require('../schema/technologies_schema').SaveDataBody,
    query: require('../schema/technologies_schema').SaveDataQuery
}), function (req, res, next) {
    queries.CreateTechnology(req.query['userUUID'], req.body, function (err, data) {
        if (err) {
            next(err);
        }

        var fullUrl = req.protocol + '://' + req.get('host') + req.baseUrl + '/';
        res.set('Location', fullUrl + data[0]['otechnologyuuid']);
        res.sendStatus(201);
    });
});

module.exports = router;