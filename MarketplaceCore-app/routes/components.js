/* ##########################################################################
 -- Author: Marcel Ely Gomes
 -- Company: Trumpf Werkzeugmaschine GmbH & Co KG
 -- CreatedAt: 2017-03-08
 -- Description: Routing requests for components
 -- ##########################################################################*/

var express = require('express');
var router = express.Router();
var logger = require('../global/logger');
var validate = require('express-jsonschema').validate;
var queries = require('../connectors/pg-queries');


router.get('/', validate({query: require('../schema/components_schema').GetAll}), function (req, res, next) {

    if(req.query['componentName']) {
        queries.GetComponentByName(req.query['userUUID'], req.query['componentName'], function (err, data) {
            if (err) {
                next(err);
            }
            else {
                res.json(data);
            }
        });
    }
    else {
        queries.GetAllComponents(req.query['userUUID'], function(err,data) {
            if (err) {
                next(err);
            }
            else {
                res.json(data);
            }
        });
    }
});

router.get('/:id', validate({query: require('../schema/components_schema').GetSingle}),  function (req, res, next) {
    logger.debug(req);
    queries.GetComponentByID(req.query['userUUID'], req.params['id'], function (err, data) {
        if (err) {
            next(err);
        }
        else {
            res.json(data);
        }
    });
});

//TODO: Verify this route
router.get('/:id/technology', validate({query: require('../schema/components_schema').GetSingle}),  function (req, res, next) {
    logger.debug(req);
    queries.GetComponentsByTechnology(req.query['userUUID'], req.params['id'], function (err, data) {
        if (err) {
            next(err);
        }
        else {
            res.json(data);
        }
    });
});

router.post('/', validate({
    body: require('../schema/components_schema').SaveDataBody,
    query: require('../schema/components_schema').SaveDataQuery
}), function (req, res, next) {
    queries.SetComponent(req.query['userUUID'], req.body, function (err, data) {
        if (err) {
            next(err);
        }

        var fullUrl = req.protocol + '://' + req.get('host') + req.baseUrl + '/';
        res.set('Location', fullUrl + data[0]['componentuuid']);
        res.sendStatus(201);
    });
});

module.exports = router;