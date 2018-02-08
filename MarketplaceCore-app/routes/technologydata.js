/* ##########################################################################
 -- Author: Marcel Ely Gomes
 -- Company: Trumpf Werkzeugmaschine GmbH & Co KG
 -- CreatedAt: 2017-02-27
 -- Description: Routing service for TechnologyData
 -- ##########################################################################*/

const express = require('express');
const router = express.Router();
const logger = require('../global/logger');

const {Validator, ValidationError} = require('express-json-validator-middleware');
const validator = new Validator({allErrors: true});
const validationSchema = require('../schema/technologydata_schema');
const validate = validator.validate;

const TechnologyData = require('../database/model/technologydata');
const Component = require('../database/model/component');
const helper = require('../services/helper_service');
const licenseCentral = require('../adapter/license_central_adapter');
const dbProductCode = require('../database/function/productCode');
const imageService = require('../services/image_service');
const CONFIG = require('../config/config_loader');
const path = require('path');

router.get('/',
    validate({
        query: validationSchema.Get_Query,
        body: validationSchema.Empty
    }),
    function (req, res, next) {


        if (req.query['user']) {
            TechnologyData.FindForUser(req.query['user'], req.token.user.id, req.token.user.roles, function (err, data) {
                if (err) {
                    next(err);
                }
                else {
                    res.json(data);
                }
            });
        }
        else {
            TechnologyData.FindAll(req.token.user.id, req.token.user.roles, req.query, function (err, data) {
                if (err) {
                    next(err);
                }
                else {
                    res.json(data);
                }
            });
        }
    });

router.get('/:id', validate({query: validationSchema.Empty, body: validationSchema.Empty}), function (req, res, next) {

    new TechnologyData().FindSingle(req.token.user.id, req.token.user.roles, req.params['id'], function (err, data) {
        if (err) {
            next(err);
        }
        else {
            res.json(data);
        }
    });
});

router.post('/', validate({
    body: validationSchema.SaveData_Body,
    query: validationSchema.Empty
}), function (req, res, next) {
    const data = req.body;

    TechnologyData.FindByName(req.token.user.id, req.token.user.roles, data['technologyDataName'], function (err, tData) {
        if (err) {
            return next(err);
        }

        if (tData) {
            res.status(409);
            return res.send('Technologydata with given name already exists.');
        }

        dbProductCode.GetNewProductCode(CONFIG.USER.uuid, function (err, productCode) {
            if (err) {
                return next(err);
            }

            licenseCentral.createAndEncrypt(CONFIG.PRODUCT_CODE_PREFIX + productCode, data['technologyDataName'], productCode, data['technologyData'], function (err, encryptedData) {
                if (err) {
                    return next(err);
                }

                const techData = new TechnologyData();

                techData.technologydataname = data['technologyDataName'];
                techData.technologydata = encryptedData;
                techData.technologydatadescription = data['technologyDataDescription'];
                techData.technologyuuid = data['technologyUUID'];
                techData.licensefee = data['licenseFee'];
                techData.taglist = data['tagList'];
                techData.componentlist = data['componentList'];
                techData.productcode = productCode;
                techData.technologydataimgref = imageService.getRandomImagePath();
                techData.backgroundcolor = data['backgroundColor'];

                techData.Create(req.token.user.id, req.token.user.roles, function (err, data) {
                    if (err) {
                        return next(err);
                    }

                    const fullUrl = helper.buildFullUrlFromRequest(req);
                    res.set('Location', fullUrl + data['technologydatauuid']);
                    res.sendStatus(201);
                });
            });
        });
    });
});


router.get('/:id/image', validate({
    query: validationSchema.Empty,
    body: validationSchema.Empty
}), function (req, res, next) {


    new TechnologyData().FindSingle(req.token.user.id, req.token.user.roles, req.params['id'], function (err, technologyData) {
        if (err) {
            next(err);
        }
        else {
            if (!technologyData || !Object.keys(technologyData).length) {
                logger.info('No technologyData found for id: ' + req.params['id']);
                res.sendStatus(404);

                return;
            }

            const imgPath = technologyData.technologydataimgref;
            if (imgPath) {
                res.sendFile(path.resolve(imgPath));
            }
            else {
                logger.info('No image found for technologyData. Sending default image instead');
                res.sendFile(path.resolve(imageService.getDefaultImagePathForUUID(req.params['id'])));
            }

        }
    });

});

router.get('/:id/components', validate({
    query: validationSchema.Empty,
    body: validationSchema.Empty
}), function (req, res, next) {

    new Component().FindByTechnologyDataId(req.token.user.id, req.token.user.roles, req.params['id'], function (err, components) {
        if (err) {
            next(err);
        }
        else {
            res.json(components);
        }
    });
});

router.delete('/:id/delete', validate({
    query: validationSchema.Empty,
    body: validationSchema.Empty
}), function (req, res, next) {

    new TechnologyData().Delete(req.params['id'], req.token.user.id, req.token.user.roles, function (err, data) {
        if (err) {
            next(err);
        }
        else {
            res.json(data);
        }
    });
});

module.exports = router;