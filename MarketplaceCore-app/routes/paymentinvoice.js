/**
 * Created by elygomesma on 15.02.17.
 */

var express = require('express');
var router = express.Router();
var logger = require('../global/logger');
var validate = require('express-jsonschema').validate;
var queries = require('../connectors/pg-queries');


router.get('/offerRequest/:id', validate({query: require('../schema/paymentinvoice_schema').GetAll}), function (req, res, next) {

    queries.GetPaymentInvoiceForOfferRequest(req.query['userUUID'], req.params['id'], function (err, data) {
            if (err) {
                next(err);
            }
            else {
                res.json(data);
            }
        });

});

module.exports = router;