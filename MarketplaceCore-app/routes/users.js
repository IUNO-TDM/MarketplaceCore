/* ##########################################################################
 -- Author: Marcel Ely Gomes
 -- Company: Trumpf Werkzeugmaschine GmbH & Co KG
 -- CreatedAt: 2017-03-02
 -- Description: Routing service for TechnologyData
 -- ##########################################################################*/

var express = require('express');
var router = express.Router();
var logger = require('../global/logger');
var validate = require('express-jsonschema').validate;
var queries = require('../connectors/pg-queries');

/*router.get('/', validate({query: require('../schema/users_schema').GetSingle}), function (req, res, next) {
 logger.debug(req);
 queries.GetAllUsers(req.query['userUUID'], function(err, data){
 if (err){
 next(err);
 }
 else {
 res.json(data);
 }
 });
 });*/

router.get('/', validate({query: require('../schema/users_schema').GetSingle}), function (req, res, next) {
    queries.GetUserByName(req.query['userUUID'], req.query['firstName'], req.query['lastName'], function (err, data) {
        if (err) {
            next(err);
        }
        else {
            res.json(data);
        }
    });
});

router.get('/:id', validate({query: require('../schema/users_schema').GetSingle}), function (req, res, next) {
    queries.GetUserByID(req.query['userUUID'], req.params['id'], function (err, data) {
        if (err) {
            next(err);
        }
        else {
            res.json(data);
        }
    });
});

router.post('/', validate({
    body: require('../schema/users_schema').SaveDataBody,
    query: require('../schema/users_schema').SaveDataQuery
}), function (req, res, next) {
    queries.CreateUser(req.query['userUUID'], req.body, function (err, data) {
        if (err) {
            next(err);
        }

        var fullUrl = req.protocol + '://' + req.get('host') + req.baseUrl + '/';
        res.set('Location', fullUrl + data[0]['createuser']);
        res.sendStatus(201);
    });
});

module.exports = router;