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
var helper = require('../services/helper_service');
var User = require('../database/model/user');

router.get('/:id', validate({query: require('../schema/users_schema').GetSingle}), function (req, res, next) {

    new User().FindSingle(req.query['userUUID'], req.params['id'], function (err, data) {
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

    var _user = new User();
    _user.userfirstname = req.body.firstName;
    _user.userlastname = req.body.lastName;
    _user.useremail = req.body.emailAddress;

    _user.Create(req.query['userUUID'], function(err, data) {
        if (err) {
            next(err);
        }

        var fullUrl = helper.buildFullUrlFromRequest(req);
        res.set('Location', fullUrl + data[0]['useruuid']);
        res.sendStatus(201);
    });
});

router.get('/:id/image', validate({query: require('../schema/users_schema').GetSingle}), function (req, res, next) {

    new User().FindSingle(req.query['userUUID'], req.params['id'], function (err, data) {
        if (err) {
            next(err);
        }
        else {
            if (!data || !Object.keys(data).length) {
                logger.info('No user found for id: ' + req.param['id']);
                res.sendStatus(404);

                return;
            }

            var imgPath = data.imgpath;

            if (imgPath) {
                var path = require('path');
                res.sendFile(path.resolve(imgPath));
            }
            else {
                logger.info('No image found for user');
                res.sendStatus(404);
            }

        }
    });

});
module.exports = router;