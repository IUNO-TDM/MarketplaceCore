const express = require('express');
const router = express.Router();
const logger = require('../global/logger');

const {Validator, ValidationError} = require('express-json-validator-middleware');
const validator = new Validator({allErrors: true});
const validate = validator.validate;

const protocol_service = require('../services/protocol_service');
const helper = require('../services/helper_service');
const licenseCentral = require('../adapter/license_central_adapter');

const bruteForceProtection = require('../services/brute_force_protection');
const config = require('../config/config_loader');


router.post('/:hsmId/update',
    bruteForceProtection.global,
    validate({
        query: require('../schema/cmdongle_schema').Empty,
        body: require('../schema/cmdongle_schema').LicenseUpdate_Body
    }), function (req, res, next) {


        const hsmId = req.params['hsmId'];
        const racBuffer = req.body.RAC;

        const protocol = {
            eventType: 'licenseupdate',
            timestamp: new Date().toISOString(),
            payload: {
                hsmId: hsmId
            }
        };

        protocol_service.newProtocol(protocol,  req.token.client.id, req.token.user.id, req.token.user.roles, (err, data) => {
            if (err) {
                logger.warn("Could not create Protocol for License Update: ", err)
            }
        });


        licenseCentral.doLicenseUpdate(hsmId, racBuffer, function (err, rauBuffer, isOutOfDate) {
            if (err) {
                return next(err);
            }

            res.json({
                RAU: rauBuffer,
                isOutOfDate: isOutOfDate
            });
        });

    });

router.post('/:hsmId/update/confirm',
    bruteForceProtection.global,
    validate({
        query: require('../schema/cmdongle_schema').Empty,
        body: require('../schema/cmdongle_schema').LicenseUpdate_Body
    }), function (req, res, next) {


        const hsmId = req.params['hsmId'];
        const racBuffer = req.body.RAC;

        const protocol = {
            eventType: 'licenseupdateconfirm',
            timestamp: new Date().toISOString(),
            payload: {
                hsmId: hsmId
            }
        };

        protocol_service.newProtocol(protocol, req.token.client.id, req.token.user.id, req.token.user.roles, (err, data) => {
            if (err) {
                logger.warn("Could not create Protocol for License Update Confirm: ", err)
            }
        });

        licenseCentral.doConfirmUpdate(racBuffer, function (err) {
            if (err) {
                return next(err);
            }

            res.sendStatus(200);
        });

    });

module.exports = router;