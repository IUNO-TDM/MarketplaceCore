/* ##########################################################################
 -- Author: Marcel Ely Gomes
 -- Company: Trumpf Werkzeugmaschine GmbH & Co KG
 -- CreatedAt: 2017-02-27
 -- Description: Routing service for TechnologyData
 -- ##########################################################################*/

const express = require('express');
const router = express.Router();
const logger = require('../global/logger');
const validate = require('express-jsonschema').validate;
const TechnologyData = require('../database/model/technologydata');
const Component = require('../database/model/component');
const helper = require('../services/helper_service');
const licenseCentral = require('../adapter/license_central_adapter');


router.get('/', validate({query: require('../schema/technologydata_schema').GetAll}), function (req, res, next) {

    new TechnologyData().FindAll(req.query['userUUID'], req.token.user.roles, req.query, function (err, data) {
        if (err) {
            next(err);
        }
        else {
            res.json(data);
        }
    });
});

router.get('/:id', validate({query: require('../schema/technologydata_schema').GetSingle}), function (req, res, next) {

    new TechnologyData().FindSingle(req.query['userUUID'], req.token.user.roles, req.params['id'], function (err, data) {
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
    const data = req.body;

    //TODO: [1] Request next sequence for product id from database
    const productCode = 12345;

    licenseCentral.createAndEncrypt(productCode + '', data['technologyDataName'], productCode, data['technologyData'], function(err, encryptedData){
        if (err) {
            return next(err);
        }

        const techData = new TechnologyData();


        techData.technologydataname = data['technologyDataName'];
        techData.technologydata = encryptedData;
        techData.technologydatadescription = data['technologyDataDescription'];
        techData.technologyid = data['technologyUUID'];
        techData.licensefee = data['licenseFee'];
        techData.retailprice = data['retailPrice'];
        techData.taglist = data['tagList'];
        techData.componentlist = data['componentList'];
        techData.productcode = productCode;

        techData.Create(req.query['userUUID'], req.token.user.roles, function (err, data) {
            if (err) {
                return next(err);
            }

            const fullUrl = helper.buildFullUrlFromRequest(req);
            res.set('Location', fullUrl + data['technologydatauuid']);
            res.sendStatus(201);
        });
    });
});


router.get('/:id/image', validate({query: require('../schema/technologydata_schema').GetSingle}), function (req, res, next) {


    new TechnologyData().FindSingle(req.query['userUUID'], req.token.user.roles, req.params['id'], function (err, technologyData) {
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

            var path = require('path');
            if (imgPath) {
                res.sendFile(path.resolve(imgPath));
            }
            else {
                logger.info('No image found for technologyData. Sending default image instead');
                res.sendFile(path.resolve('images/recipes/default.svg'));
            }

        }
    });

});

router.get('/:id/components', validate({query: require('../schema/technologydata_schema').GetSingle}), function (req, res, next) {

    new Component().FindByTechnologyDataId(req.query['userUUID'], req.token.user.roles, req.params['id'], function (err, components) {
        if (err) {
            next(err);
        }
        else {
            res.json(components);
        }
    });
});

module.exports = router;