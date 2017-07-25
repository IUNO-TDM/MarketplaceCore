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
var TechnologyData = require('../database/model/technologydata');
var Component = require('../database/model/component');
var helper = require('../services/helper_service');


router.get('/', validate({query: require('../schema/technologydata_schema').GetAll}), function (req, res, next) {

    new TechnologyData().FindAll(req.query['userUUID'], req.token.user.rolename, req.query, function (err, data) {
        if (err) {
            next(err);
        }
        else {
            res.json(data);
        }
    });
});

router.get('/:id', validate({query: require('../schema/technologydata_schema').GetSingle}), function (req, res, next) {

    new TechnologyData().FindSingle(req.query['userUUID'], req.token.user.rolename, req.params['id'],   function (err, data) {
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

    var techData = new TechnologyData();
    var data = req.body;

    techData.technologydataname = data['technologyDataName'];
    techData.technologydata = data['technologyData'];
    techData.technologydatadescription = data['technologyDataDescription'];
    techData.technologyid = data['technologyUUID'];
    techData.licensefee = data['licenseFee'];
    techData.retailprice = data['retailPrice'];
    techData.taglist = data['tagList'];
    techData.componentlist = data['componentList'];

    techData.Create(req.query['userUUID'], req.token.user.rolename, function (err, data) {
        if (err) {
            next(err);
        }

        var fullUrl = helper.buildFullUrlFromRequest(req);
        res.set('Location', fullUrl + data[0]['technologydatauuid']);
        res.sendStatus(201);
    });
});


router.get('/:id/image', validate({query: require('../schema/technologydata_schema').GetSingle}), function (req, res, next) {


    new TechnologyData().FindSingle(req.query['userUUID'], req.token.user.rolename, req.params['id'], function (err, technologyData) {
        if (err) {
            next(err);
        }
        else {
            if (!technologyData || !Object.keys(technologyData).length) {
                logger.info('No technologyData found for id: ' + req.param['id']);
                res.sendStatus(404);

                return;
            }

            var imgPath = technologyData.technologydataimgref;

            if (imgPath) {
                var path = require('path');
                res.sendFile(path.resolve(imgPath));
            }
            else {
                logger.info('No image found for technologyData');
                res.sendStatus(404);
            }

        }
    });

});

router.get('/:id/components', validate({query: require('../schema/technologydata_schema').GetSingle}), function (req, res, next) {

    new Component().FindByTechnologyDataId(req.query['userUUID'], req.token.user.rolename, req.params['id'], function (err, components) {
        if (err) {
            next(err);
        }
        else {
            res.json(components);
        }
    });
});

module.exports = router;