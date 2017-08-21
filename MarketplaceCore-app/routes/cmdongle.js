const express = require('express');
const router = express.Router();
const logger = require('../global/logger');
const validate = require('express-jsonschema').validate;
const helper = require('../services/helper_service');
const licenseCentral = require('../adapter/license_central_adapter');

router.post('/:cmSerial/update', validate({
    query: require('../schema/cmdongle_schema').LicenseUpdate_Query,
    body: require('../schema/cmdongle_schema').LicenseUpdate_Body
}), function (req, res, next) {


    const cmSerial = req.param('cmSerial');
    const racBuffer = req.body.RAC;

    licenseCentral.doLicenseUpdate(cmSerial, racBuffer, function (err, rauBuffer) {
        if (err) {
            return next(err);
        }

        res.json({
            RAU: rauBuffer
        });
    });

});

module.exports = router;