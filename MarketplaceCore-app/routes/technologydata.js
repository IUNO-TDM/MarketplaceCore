/* ##########################################################################
 -- Author: Marcel Ely Gomes
 -- Company: Trumpf Werkzeugmaschine GmbH & Co KG
 -- CreatedAt: 2017-02-27
 -- Description: Routing service for TechnologyData
 -- ##########################################################################*/

const express = require('express');
const router = express.Router();

const {Validator, ValidationError} = require('express-json-validator-middleware');
const validator = new Validator({allErrors: true});
const validationSchema = require('../schema/technologydata_schema');
const validationSchema_components = require('../schema/components_schema');
const validate = validator.validate;

const logger = require('../global/logger');
const TechnologyData = require('../database/model/technologydata');
const Component = require('../database/model/component');
const helper = require('../services/helper_service');
const licenseCentral = require('../adapter/license_central_adapter');
const dbProductCode = require('../database/function/productCode');
const imageService = require('../services/image_service');
const CONFIG = require('../config/config_loader');
const path = require('path');
const bruteForceProtection = require('../services/brute_force_protection');
const fs = require('fs');


router.get('/',
    validate({
        query: validationSchema.Get_Query,
        body: validationSchema.Empty
    }),
    function (req, res, next) {


        if (req.query['user']) {
            TechnologyData.FindForUser(req.query['user'], req.token.user.id, req.token.user.roles, req.query['lang'], function (err, data) {
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

    TechnologyData.FindSingle(req.token.user.id, req.token.user.roles, req.params['id'], function (err, data) {
        if (err) {
            next(err);
        }
        else {
            res.json(data);
        }
    });
});

router.post('/', bruteForceProtection.global,
    validate({
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

                licenseCentral.createAndEncrypt(CONFIG.PRODUCT_CODE_PREFIX + productCode, 'DEPRECATED_NOT_USED', productCode, data['technologyData'], function (err, encryptedData) {
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
                    techData.isfile = data['isFile'];


                    if (data['image']) {
                        techData.technologydataimgref = imageService.saveImage(req.token.user.id, data['technologyDataName'], data['image']);
                    }
                    else {
                        techData.technologydataimgref = imageService.getRandomImagePath();
                    }


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


    TechnologyData.FindSingle(req.token.user.id, req.token.user.roles, req.params['id'], function (err, technologyData) {
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
    query: validationSchema_components.Components_Query,
    body: validationSchema_components.Empty
}), function (req, res, next) {

    Component.FindByTechnologyDataId(req.token.user.id, req.token.user.roles, req.query['lang'], req.params['id'], function (err, components) {
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

    TechnologyData.Delete(req.params['id'], req.token.user.id, req.token.user.roles, function (err, data) {
        if (err) {
            next(err);
        }
        else {
            res.json(data);
        }
    });
});

router.get('/:id/content', validate({
    query: validationSchema.GetContent_Query,
    body: validationSchema.Empty
}), function (req, res, next) {

    TechnologyData.FindWithContent(req.params['id'], req.query['offerId'], req.token.client.id, req.token.user.id, req.token.user.roles,
        (err, data) => {
            if (err) {
                return next(err);
            }

            if (!data) {
                return res.sendStatus(402)
            }

            if (data.isfile) {
                if (!data.filepath || data.filepath.length <= 0) {
                    return res.sendStatus(402);
                }
                res.header('key', data.technologydata);
                res.sendFile(path.resolve(`${CONFIG.FILE_DIR}/${data.filepath}`));
            }
            else {
                res.json(data.technologydata);
            }
        }
    );
});

function deleteFile(path) {
    fs.unlink(path, (err) => {
        if (err) {
            logger.warn('[routes/technologydata] could not delete file after update failed');
        }
    });
}

router.post('/:id/content',
    bruteForceProtection.fileupload,
    require('../services/file_upload_handler'),
    function (req, res, next) {

        const data = req.data;

        if (!req.file || !req.file.path) {
            return res.sendStatus(400);
        }

        logger.debug(`File stored to: ${req.file.path}`);

        if (!data) {
            deleteFile(req.file.path);

            return res.sendStatus(404);
        }

        const targetPath = `${CONFIG.FILE_DIR}/${req.file.filename}`;
        data.filepath = req.file.filename;

        if (fs.existsSync(targetPath)) {
            logger.crit('[routes/technologydata] Technology data content file already exists.');
            deleteFile(req.file.path);
            return res.sendStatus(500);
        }

        data.Update(req.token.user.id, req.token.user.roles, (err) => {
            if (err) {
                deleteFile(req.file.path);
                return next(err);
            }

            fs.rename(req.file.path, targetPath, (err) => {
                if (err) {
                    logger.crit('[routes/technologydata] Error while moving uploaded file from tmp dir to upload dir');

                    return res.sendStatus(500);
                }

                return res.sendStatus(200);
            });
        });
    });

module.exports = router;