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
    if(req.query['firstName'] && req.query['lastName']){
        queries.GetUserByName(req.query['userUUID'], req.query['firstName'], req.query['lastName'], function (err, data) {
            if (err) {
                next(err);
            }
            else {
                res.json(data);
            }
        });
    }
    else {
        queries.GetUserByID(req.query['userUUID'], function (err, data) {
            if (err) {
                next(err);
            }
            else {
                res.json(data);
            }
        });
    }
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
        res.set('Location', fullUrl + data[0]['ouseruuid']);
        res.sendStatus(201);
    });
});

router.get('/:id/image', validate({query: require('../schema/users_schema').GetSingle}), function (req, res, next) {

    queries.GetUserByID(req.query['userUUID'], req.params['id'], function (err, data) {
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
                var fs = require('fs');

                fs.readFile(imgPath, function (err, fileBuffer) {
                    if (err) {
                        logger.warn('Cannot read file from path: ' + imgPath);
                        logger.warn(err);

                        res.sendStatus(500);

                        return;
                    }

                    res.set('Content-Type', 'image/jpg');
                    res.send(fileBuffer);
                });
            }

        }
    });

});
module.exports = router;