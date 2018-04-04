const express = require('express');
const router = express.Router();
const logger = require('../global/logger');
const {Validator, ValidationError} = require('express-json-validator-middleware');
const validator = new Validator({allErrors: true});
const validation_schema = require('../schema/protocols_schema');
const validate = validator.validate;
const dbProtocols = require('../database/function/protocol');
const authenticationService = require('../services/authentication_service');

router.post('/:clientId', validate({
    query: validation_schema.Empty,
    body: validation_schema.Protocol_Body
}), function (req, res, next) {
    let clientId = req.params['clientId'];
    let protocol = req.body;

    logger.info("Protocol of type \"" + protocol.eventType + "\" received from " + clientId);

    dbProtocols.CreateProtocols(protocol, clientId, req.token.user.id, req.token.user.roles, function (err, data) {
        if (err) {
            next(err);
        }
        else {
            res.json(data);
        }
    });
});

router.get('/',
    authenticationService.isAdmin,
    validate({
        query: validation_schema.Protocol_Query,
        body: validation_schema.Empty
    }), function (req, res, next) {
        dbProtocols.GetProtocols(req.query['eventType'], req.query['from'], req.query['to'], req.token.user.id,
            req.token.user.roles, function (err, data) {

                if (err) {
                    return next(err);
                }

                res.json(data);

            });
    });

module.exports = router;