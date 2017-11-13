/* ##########################################################################
 -- Author: Marcel Ely Gomes
 -- Company: Trumpf Werkzeugmaschine GmbH & Co KG
 -- CreatedAt: 2017-03-08
 -- Description: Routing requests for components
 -- ##########################################################################*/

const express = require('express');
const router = express.Router();
const logger = require('../global/logger');

const {Validator, ValidationError} = require('express-json-validator-middleware');
const validator = new Validator({allErrors: true});
const validate = validator.validate;
const validation_schema = require('../schema/components_schema');

const Component = require('../database/model/component');
const helper = require('../services/helper_service');


router.get('/', validate({query: validation_schema.Empty, body: validation_schema.Empty}), function (req, res, next) {

    Component.FindAll(req.token.user.id, req.token.user.roles, req.query, function (err, data) {
        if (err) {
            next(err);
        }
        else {
            res.json(data);
        }
    });
});

router.get('/:id', validate({query: validation_schema.Empty, body: validation_schema.Empty}), function (req, res, next) {
    Component.FindSingle(req.token.user.id, req.token.user.roles, req.params['id'], function (err, data) {
        if (err) {
            next(err);
        }
        else {
            res.json(data);
        }
    });
});

router.post('/', validate({
    body: validation_schema.SaveDataBody,
    query: validation_schema.Empty
}), function (req, res, next) {

    logger.warn('[components] POST components disabled as it is not implemented correctly and should not being used.)');
    return res.status(500).send('Route disabled!');

    // TODO: Refactor validation schema before using this route.


    const comp = new Component();

    const data = req.body;

    comp.componentname = data['componentName'];
    comp.componentparentname = data['componentParentName']; //TODO: Refactor this. Why would we identify the parent component by name !?
    comp.componentdescription = data['componentDescription'];
    comp.attributelist = data['attributeList'];
    comp.technologylist = data['technologyList'];

    comp.Create(req.token.user.id, req.token.user.roles, function (err, data) {
        if (err) {
            next(err);
        }
        else {
            var fullUrl = helper.buildFullUrlFromRequest(req);
            res.set('Location', fullUrl + data[0]['componentuuid']);
            res.sendStatus(201);
        }
    });
});

module.exports = router;