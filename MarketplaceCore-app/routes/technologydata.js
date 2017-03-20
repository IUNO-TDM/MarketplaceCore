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

    queries.GetTechnologyDataByID(req.query['userUUID'], req.params['id'], function (err, data) {
        if (err) {
            next(err);
        }
        else {
            logger.debug('TechDataResponse: ' + JSON.stringify(data));
            res.json(data);
        }
    });

});

router.post('/', validate({
    body: require('../schema/technologydata_schema').SaveDataBody,
    query: require('../schema/technologydata_schema').SaveDataQuery
}), function (req, res, next) {
    queries.SetTechnologyData(req.query['userUUID'], req.body, function (err, data) {
        if (err) {
            next(err);
        }

        var fullUrl = req.protocol + '://' + req.get('host') + req.baseUrl + '/';
        res.set('Location', fullUrl + data[0]['technologydatauuid']);
        res.sendStatus(201);
    });
});

router.get('/:id', validate({query: require('../schema/technologydata_schema').GetSingle}), function (req, res, next) {

    queries.GetTechnologyDataByID(req.query['userUUID'], req.params['id'], function (err, data) {
        if (err) {
            next(err);
        }
        else {
            if (!data || !Object.keys(data).length) {
                logger.info('No technology data found for id: ' + req.param['id']);
                res.sendStatus(404);

                return;
            }

            var imgPath = data.technologydataimgref;

            if (imgPath) {
                var fs = require('fs');

                fs.readFile(imgPath, function (err, fileBuffer) {
                    if (err) {
                        logger.warn('Cannot read file from path: ' + imgPath);
                        logger.warn(err);

                        res.sendStatus(500);

                        return;
                    }

                    res.set('Content-Type', 'image/jpg');
                    res.send(fileBuffer);
                });
            }

        }
    });

});

module.exports = router;