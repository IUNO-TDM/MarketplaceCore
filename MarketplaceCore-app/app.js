var express = require('express');
var path = require('path');
var favicon = require('serve-favicon');
var logger = require('morgan');
var cookieParser = require('cookie-parser');
var bodyParser = require('body-parser');
var validate = require('express-jsonschema').validate;
var authentication = require('./services/authentication_service');

var app = express();

// basic setup
app.use(logger('dev'));

app.use(bodyParser.json());
app.use(bodyParser.urlencoded({ extended: false }));
app.use(cookieParser());

app.use('/', validate({query: require('./schema/oauth_schema').AccessToken}), authentication.oAuth);
// Load all routes
app.use('/technologydata', require('./routes/technologydata'));
app.use('/components', require('./routes/components'));
app.use('/offers', require('./routes/offers'));
app.use('/offers', require('./routes/offers'));
app.use('/reports', require('./routes/reports'));

// catch 404 and forward to error handler
app.use(function(req, res, next) {
    var err = new Error('Not Found');
    err.status = 404;
    next(err);
});

// error handler

// Custom validation error
app.use(function(err, req, res, next) {

    var responseData;

    if (err.name === 'JsonSchemaValidation') {
        // Log the error however you please
        console.log(err.message);
        // logs "express-jsonschema: Invalid data found"

        // Set a bad request http response status or whatever you want
        res.status(400);

        // Format the response body however you want
        responseData = {
            statusText: 'Bad Request',
            jsonSchemaValidation: true,
            validations: err.validations  // All of your validation information
        };

        res.json(responseData);
    } else {
        // pass error to next error middleware handler
        next(err);
    }
});


if (app.get('env') === 'development') {
    app.use(function (err, req, res, next) {
        console.error(err.stack);
        res.status(err.status || 500);
        res.json({
            message: err.message,
            error: err
        });
    });
} else {
    app.use(function (err, req, res, next) {
        console.error(err.stack);
        // Send error details to the client only when the status is 4XX
        if (err.status && err.status >= 400 && err.status < 500) {
            res.status = err.status;
            res.json({
                message: err.message,
                error: err
            });
        }
        res.status(500).send('Something broke!');
    });
}


module.exports = app;
