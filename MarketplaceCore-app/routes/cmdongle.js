const express = require('express');
const router = express.Router();
const logger = require('../global/logger');

const { Validator, ValidationError } = require('express-json-validator-middleware');
const validator = new Validator({allErrors: true});
const validate = validator.validate;

const helper = require('../services/helper_service');
const licenseCentral = require('../adapter/license_central_adapter');

router.post('/:hsmId/update', validate({
    query: require('../schema/cmdongle_schema').Empty,
    body: require('../schema/cmdongle_schema').LicenseUpdate_Body
}), function (req, res, next) {


    const hsmId = req.params['hsmId'];
    const racBuffer = req.body.RAC;

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

router.post('/:hsmId/update/confirm', validate({
    query: require('../schema/cmdongle_schema').Empty,
    body: require('../schema/cmdongle_schema').LicenseUpdate_Body
}), function (req, res, next) {


    const hsmId = req.params['hsmId'];
    const racBuffer = req.body.RAC;

    licenseCentral.doConfirmUpdate(racBuffer, function (err) {
        if (err) {
            return next(err);
        }

        res.sendStatus(200);
    });

});

module.exports = router;