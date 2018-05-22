const express = require('express');
const logger = require('morgan');
const cookieParser = require('cookie-parser');
const bodyParser = require('body-parser');
const queryParser = require('express-query-int');
const authentication = require('./services/authentication_service');
const contentTypeValidation = require('./services/content_type_validation');

const app = express();

// basic setup
app.use(logger('dev'));

// Accept JSON only
app.use('/', contentTypeValidation);

app.use('/cmdongle', bodyParser.json({
    limit: '50mb'
}));

app.use('/', bodyParser.json({
    limit: '10kb'
}));

app.use(queryParser());
app.use(bodyParser.urlencoded({extended: false}));
app.use(cookieParser());

app.use('/', authentication.oAuth);

// Load all routes
app.use('/technologydata', require('./routes/technologydata'));
app.use('/components', require('./routes/components'));
app.use('/offers', require('./routes/offers'));
app.use('/offers', require('./routes/offers'));
app.use('/reports', require('./routes/reports'));
app.use('/cmdongle', require('./routes/cmdongle'));
app.use('/vault', require('./routes/vault'));
app.use('/protocols', require('./routes/protocols'));

// catch 404 and forward to error handler
app.use(function (req, res, next) {
    const err = new Error('Not Found');
    err.status = 404;
    next(err);
});

// error handler

// Custom validation error
app.use(function (err, req, res, next) {

    let responseData;

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

        return res.json(responseData);
    }

    if (err.name === 'JsonSchemaValidationError') {
        // Log the error however you please
        console.log(JSON.stringify(err.validationErrors));

        // Set a bad request http response status or whatever you want
        res.status(400);

        // Format the response body however you want
        responseData = {
            statusText: 'Bad Request',
            jsonSchemaValidation: true,
            validations: err.validationErrors  // All of your validation information
        };

        return res.json(responseData);
    }

    next(err);
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
            res.status(err.status);
            res.json({
                message: err.message,
                error: err
            });
        }
        else {
            res.status(500);
            res.send('Something broke!');
        }
    });
}


module.exports = app;
