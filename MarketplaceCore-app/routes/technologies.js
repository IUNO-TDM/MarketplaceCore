/* ##########################################################################
 -- Author: Marcel Ely Gomes
 -- Company: Trumpf Werkzeugmaschine GmbH & Co KG
 -- CreatedAt: 2017-02-27
 -- Description: Routing service for TechnologyData
 -- ##########################################################################*/

var express = require('express');
var router = express.Router();
var logger = require('../global/logger');
var validate = require('express-jsonschema').validate;


router.get('/', validate({query: require('../schema/technologies_schema').GetAll}), function (req, res, next) {
    throw {name: "NotImplementedError", message: "Function not implemented yet"}; //TODO: Implement this function if needed
});

router.get('/:id', validate({query: require('../schema/technologies_schema').GetSingle}), function (req, res, next) {
    throw {name: "NotImplementedError", message: "Function not implemented yet"}; //TODO: Implement this function if needed
});

router.post('/', validate({
    body: require('../schema/technologies_schema').SaveDataBody,
    query: require('../schema/technologies_schema').SaveDataQuery
}), function (req, res, next) {
    throw {name: "NotImplementedError", message: "Function not implemented yet"}; //TODO: Implement this function if needed
});

module.exports = router;