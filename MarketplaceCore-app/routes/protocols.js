const express = require('express');
const router = express.Router();
const logger = require('../global/logger');
const {Validator, ValidationError} = require('express-json-validator-middleware');
const validator = new Validator({allErrors: true});
const validation_schema = require('../schema/protocol_schema');
const validate = validator.validate;
const dbProtocols = require('../database/function/protocol');

router.post('/:clientId', validate({
    query: validation_schema.Empty,
    body: validation_schema.Protocol
}), function (req, res, next) {
    let clientId = req.params['clientId'];
    let protocol = req.body;
    console.log("Protocol of type \"" + protocol.eventType + "\" received from " + clientId);

    dbProtocols.CreateProtocols(protocol, clientId, req.token.user.roles, function (err, data) {
        if (err) {
            next(err);
        }
        else {
            res.json(data);
        }
    });
});

module.exports = router;