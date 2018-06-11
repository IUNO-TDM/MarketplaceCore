const express = require('express');
const router = express.Router();
const logger = require('../global/logger');
const {Validator, ValidationError} = require('express-json-validator-middleware');
const validator = new Validator({allErrors: true});
const validation_schema = require('../schema/protocols_schema');
const validate = validator.validate;
const dbProtocols = require('../database/function/protocol');
const authenticationService = require('../services/authentication_service');
const bruteForceProtection = require('../services/brute_force_protection');

router.post('/:clientId',
    bruteForceProtection.global,
    bruteForceProtection.protocols,
    validate({
        query: validation_schema.Empty,
        body: validation_schema.Protocol_Body
    }), (req, res, next) => {
        let clientId = req.params['clientId'];
        let protocol = req.body;

        logger.info("Protocol of type \"" + protocol.eventType + "\" received from " + clientId);

        dbProtocols.CreateProtocols(protocol, clientId, req.token.user.id, req.token.user.roles, (err, data) => {
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
    }), (req, res, next) => {

        const clientId = req.query['clientId'] ? req.query['clientId'] : null;
        const limit = req.query['limit'] ? req.query['limit'] : null;

        dbProtocols.GetProtocols(
            req.query['eventType'],
            clientId,
            req.query['from'],
            req.query['to'],
            limit,
            req.token.user.id,
            req.token.user.roles,
            (err, data) => {

                if (err) {
                    return next(err);
                }

                res.json(data);

            });
    });

router.get('/last',
    authenticationService.isAdmin,
    validate({
        query: validation_schema.Protocol_Last_Query,
        body: validation_schema.Empty
    }), (req, res, next) => {

        dbProtocols.GetLastProtocolForEachClient(
            req.query['eventType'],
            req.query['from'],
            req.query['to'],
            req.token.user.id,
            req.token.user.roles,
            (err, data) => {

                if (err) {
                    return next(err);
                }

                res.json(data);

            });
    });

module.exports = router;