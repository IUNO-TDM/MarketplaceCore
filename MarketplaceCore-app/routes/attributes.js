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


router.get('/', validate({query: require('../schema/attributes_schema').GetAll}), function (req, res, next) {

    if(req.query['attributeName']) {
        queries.GetAttributeByName(req.query['userUUID'], req.query['attributeName'], function (err, data) {
            if (err) {
                next(err);
            }
            else {
                res.json(data);
            }
        });
    }
    else {
        queries.GetAllAttributes(req.query['userUUID'], function(err,data) {
            if (err) {
                next(err);
            }
            else {
                res.json(data);
            }
        });
    }
});

router.get('/:id', validate({query: require('../schema/attributes_schema').GetSingle}),  function (req, res, next) {
    logger.debug(req);
    queries.GetAttributeByID(req.query['userUUID'], req.params['id'], function (err, data) {
        if (err) {
            next(err);
        }
        else {
            res.json(data);
        }
    });
});

router.post('/', validate({
    body: require('../schema/attributes_schema').SaveDataBody,
    query: require('../schema/attributes_schema').SaveDataQuery
}), function (req, res, next) {
    queries.CreateAttribute(req.query['userUUID'], req.body, function (err, data) {
        if (err) {
            next(err);
        }

        var fullUrl = req.protocol + '://' + req.get('host') + req.baseUrl + '/';
        res.set('Location', fullUrl + data[0]['attributeuuid']);
        res.sendStatus(201);
    });
});

module.exports = router;