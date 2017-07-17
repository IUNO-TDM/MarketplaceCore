/* ##########################################################################
 -- Author: Marcel Ely Gomes
 -- Company: Trumpf Werkzeugmaschine GmbH & Co KG
 -- CreatedAt: 2017-03-08
 -- Description: Routing requests for components
 -- ##########################################################################*/

var express = require('express');
var router = express.Router();
var logger = require('../global/logger');
var validate = require('express-jsonschema').validate;
var Component = require('../database/model/component');
var helper = require('../services/helper_service');


router.get('/', validate({query: require('../schema/components_schema').GetAll}), function (req, res, next) {

    // req.token.user.role,
    new Component().FindAll(req.query['userUUID'], req.query, function (err, data) {
        if (err) {
            next(err);
        }
        else {
            res.json(data);
        }
    });
});

router.get('/:id', validate({query: require('../schema/components_schema').GetSingle}),  function (req, res, next) {
    new Component().FindSingle(req.query['userUUID'], req.params['id'], function (err, data) {
        if (err) {
            next(err);
        }
        else {
            res.json(data);
        }
    });
});

router.post('/', validate({
    body: require('../schema/components_schema').SaveDataBody,
    query: require('../schema/components_schema').SaveDataQuery
}), function (req, res, next) {
    var comp = new Component();

    comp.componentname = data['componentName'];
    comp.componentparentname = data['componentParentName']; //TODO: Refactor this. Why would we identify the parent component by name !?
    comp.componentdescription = data['componentDescription'];
    comp.attributelist = data['attributeList'];
    comp.technologylist = data['technologyList'];

    comp.Create(req.query['userUUID'], function (err, data) {
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