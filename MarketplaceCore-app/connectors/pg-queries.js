/* ##########################################################################
 -- Author: Marcel Ely Gomes
 -- Company: Trumpf Werkzeugmaschine GmbH & Co KG
 -- CreatedAt: 2017-02-27
 -- Description: Wrapped the database connection and define all database functions according to the DB Interface
 -- This script works with PostgreSQL databases
 -- ##########################################################################*/

var logger = require('../global/logger');
var pgp = require('pg-promise')();
var config = require('../config/config_loader').loadConfig();
var db = pgp(config.connectionString);

var self = {};


//<editor-fold desc="Users">
// GetAllUsers(userUUID)
self.GetAllUsers = function (userUUID, callback) {
    db.func('GetAllUsers',[userUUID])
        .then(function (data) {
            callback(null, data)
        })
        .catch(function (error) {
            logger.crit(error);
            callback(error);
        });
};

// GetUserByID(userUUID, dataId)
self.GetUserByID = function (userUUID, id, callback) {
    db.func('GetUserByID', [id, userUUID])
        .then(function (data) {
            //Only return the first element
            if (data && data.length) {
                data = data[0];
            }
            callback(null, data)
        })
        .catch(function (error) {
            logger.crit(error);
            callback(error);
        });
};

// GetUserByID(userUUID, firstName, lastName)
self.GetUserByName = function (userUUID, firstName, lastName, callback) {
    db.func('GetUserByName', [firstName, lastName, userUUID])
        .then(function (data) {
            //Only return the first element
            //TODO: Correction has to be made. It's is possible to have many users with the same name, e.g. Michael Mueller
            if (data && data.length) {
                data = data[0];
            }
            callback(null, data)
        })
        .catch(function (error) {
            logger.crit(error);
            callback(error);
        });
};

// CreateUser(userUUID, firstName, lastName, email)
self.CreateUser = function (userUUID, data, callback) {

    var firstName = data['firstName'];
    var lastName = data['lastName'];
    var emailAddress = data['emailAddress'];
    db.func('CreateUser', [firstName, lastName, emailAddress, userUUID])
        .then(function (data) {
            callback(null, data)
        })
        .catch(function (error) {
            logger.crit(error);
            callback(error);
        });
};

//</editor-fold>

//<editor-fold desc="TechnologyData">
// GetAllTechnologyData
self.GetAllTechnologyData = function (userUUID, callback) {
    db.func('GetAllTechnologyData', [userUUID])
        .then(function (data) {
            callback(null, data)
        })
        .catch(function (error) {
            logger.crit(error);
            callback(error);
        });
};

self.GetTechnologyDataByID = function (userUUID, technologyDataUUID, callback) {

    db.func('GetTechnologyDataByID', [technologyDataUUID, userUUID])
        .then(function (data) {
            //Only return the first element
            if (data && data.length) {
                data = data[0];
            }
            callback(null, data);
        })
        .catch(function (error) {
            logger.crit(error);
            callback(error);
        });
};

//Get TechnologyDataByParams
self.GetTechnologyDataByParams = function (userUUID, params, callback) {
    var technologies = params['technologies'];
    var components = params['components'];

    db.func('GetTechnologyDataByParams',
        [   components,
            technologies,
            userUUID
        ], 1
    )
        .then(function (data) {
            logger.debug('Database query result: ' + JSON.stringify(data));
            if (!data.result) {
                callback(null, []);
                return;
            }
            callback(null, data.result);
        })
        .catch(function (error) {
            logger.crit(error);
            callback(error);
        });
};

//GetTechnologyDataByName
self.GetTechnologyDataByName = function (userUUID, technologyDataName, callback) {

    db.func('GetTechnologyDataByName', [technologyDataName, userUUID])
        .then(function (data) {
            //Only return the first element
            if (data && data.length) {
                data = data[0];
            }
            callback(null, data);
        })
        .catch(function (error) {
            logger.crit(error);
            callback(error);
        });
};

//GetTechnologyDataByName
self.GetTechnologyDataByOfferRequest = function (userUUID, offerRequestUUID, callback) {

    db.func('GetTechnologyDataByOfferRequest', [offerRequestUUID, userUUID])
        .then(function (data) {
            callback(null, data)
        })
        .catch(function (error) {
            logger.crit(error);
            callback(error);
        });
};

//Get all transaction by given OfferRequest
self.GetLicenseFeeByTransaction = function (userUUID, transactionUUID, callback) {
    db.func('GetLicenseFeeByTransaction', [transactionUUID, userUUID])
        .then(function (data) {
            callback(null, data);
        })
        .catch(function (error) {
            logger.crit(error);
            callback(error);
        });
};

self.SetTechnologyData = function (userUUID, data, callback) {
    var technologyDataName = data['technologyDataName'];
    var technologyData = data['technologyData'];
    var technologyDataDescription = data['technologyDataDescription'];
    var technologyUUID = data['technologyUUID'];
    var licenseFee = data['licenseFee'];
    var retailPrice = data['retailPrice'];
    var tagList = data['tagList'];
    var componentList = data['componentList'];

    db.func('SetTechnologyData',
        [   technologyDataName,
            technologyData,
            technologyDataDescription,
            technologyUUID,
            licenseFee,
            retailPrice,
            tagList,
            componentList,
            userUUID
        ])
        .then(function (data) {
            logger.debug(data);
            callback(null, data);
        })
        .catch(function (error) {
            logger.crit(error);
            callback(error);
        });
};

//</editor-fold>

//<editor-fold desc="Technologies">
//Get all Technologies
self.GetAllTechnologies = function (userUUID, callback) {

    db.func('GetAllTechnologies', [userUUID])
        .then(function (data) {
            callback(null, data)
        })
        .catch(function (error) {
            logger.crit(error);
            callback(error);
        });
};

//Get technology by ID
self.GetTechnologyByID = function (userUUID, technologyUUID, callback) {

    db.func('GetTechnologyByID', [technologyUUID, userUUID])
        .then(function (data) {
            callback(null, data);
        })
        .catch(function (error) {
            logger.crit(error);
            callback(error);
        });
};

//Get technology by OfferRequest
self.GetTechnologyForOfferRequest = function (userUUID, offerRequestUUID, callback) {

    db.func('GetTechnologyForOfferRequest', [offerRequestUUID, userUUID])
        .then(function (data) {
            callback(null, data);
        })
        .catch(function (error) {
            logger.crit(error);
            callback(error);
        });
};

self.GetComponentByID = function (userUUID, componentUUID, callback) {

    db.func('GetComponentByID', [componentUUID, userUUID])
        .then(function (data) {
            callback(null, data);
        })
        .catch(function (error) {
            logger.crit(error);
            callback(error);
        });
};

//Get Component by Name
self.GetComponentByName = function (userUUID, componentName, callback) {

    db.func('GetComponentByName', [componentName, userUUID])
        .then(function (data) {
            callback(null, data);
        })
        .catch(function (error) {
            logger.crit(error);
            callback(error);
        });
};

//Get technology by name
self.CreateTechnology = function (userUUID, data, callback) {
        var technologyName = data['technologyName'];
        var technologyDescription = data['technologyDescription'];

        db.func('CreateTechnology',
            [   technologyName,
                technologyDescription,
                userUUID
            ])
            .then(function (data) {
                logger.debug(data);
                callback(null, data);
            })
            .catch(function (error) {
                logger.crit(error);
                callback(error);
            });
    };
//</editor-fold>

//<editor-fold desc="Components">
//Get all GetAllComponents
self.GetAllComponents = function (userUUID, callback) {

    db.func('GetAllComponents', [userUUID])
        .then(function (data) {
            callback(null, data)
        })
        .catch(function (error) {
            logger.crit(error);
            callback(error);
        });
};

//Get Component by ID
self.GetComponentByID = function (userUUID, componentUUID, callback) {

    db.func('GetComponentByID', [componentUUID, userUUID])
        .then(function (data) {
            callback(null, data);
        })
        .catch(function (error) {
            logger.crit(error);
            callback(error);
        });
};

//Get Component by Name
self.GetComponentByName = function (userUUID, componentName, callback) {

    db.func('GetComponentByName', [componentName, userUUID])
        .then(function (data) {
            callback(null, data);
        })
        .catch(function (error) {
            logger.crit(error);
            callback(error);
        });
};

//Get Component by Technology
self.GetComponentsByTechnology = function (userUUID, technologyUUID, callback) {

    db.func('GetComponentsByTechnology', [technologyUUID, userUUID])
        .then(function (data) {
            callback(null, data);
        })
        .catch(function (error) {
            logger.crit(error);
            callback(error);
        });
};

//Get Component by Technology
self.GetComponentsForTechnologyDataId = function (userUUID, technologyDataUUID, callback) {

    db.func('GetComponentsForTechnologyDataId', [technologyDataUUID, userUUID])
        .then(function (data) {
            callback(null, data);
        })
        .catch(function (error) {
            logger.crit(error);
            callback(error);
        });
};

//Set component
self.SetComponent = function (userUUID, data, callback) {
    var componentName = data['componentName'];
    var componentParentName = data['componentParentName'];
    var componentDescription = data['componentDescription'];
    var attributeList = data['attributeList'];
    var technologyList = data['technologyList'];

    db.func('SetComponent',
        [   componentName,
            componentParentName,
            componentDescription,
            attributeList,
            technologyList,
            userUUID
        ])
        .then(function (data) {
            logger.debug(data);
            callback(null, data);
        })
        .catch(function (error) {
            logger.crit(error);
            callback(error);
        });
};
//</editor-fold>

//<editor-fold desc="Attributes">
//Get all GetAllAttributes
self.GetAllAttributes = function (userUUID, callback) {

    db.func('GetAllAttributes', userUUID)
        .then(function (data) {
            callback(null, data)
        })
        .catch(function (error) {
            logger.crit(error);
            callback(error);
        });
};

//Get Attribute by ID
self.GetAttributeByID = function (userUUID, attributeUUID, callback) {

    db.func('GetAttributeByID', [attributeUUID, userUUID])
        .then(function (data) {
            callback(null, data);
        })
        .catch(function (error) {
            logger.crit(error);
            callback(error);
        });
};

//Get Attribute by Name
self.GetAttributeByName = function (userUUID, attributeName, callback) {

    db.func('GetAttributeByName', [attributeName, userUUID])
        .then(function (data) {
            callback(null, data);
        })
        .catch(function (error) {
            logger.crit(error);
            callback(error);
        });
};

//Create Attribute
self.CreateAttribute = function (userUUID, data, callback) {
    var attributeName = data['attributeName'];

    db.func('CreateAttribute',
        [   attributeName,
            userUUID
        ])
        .then(function (data) {
            logger.debug(data);
            callback(null, data);
        })
        .catch(function (error) {
            logger.crit(error);
            callback(error);
        });
};
//</editor-fold>

//<editor-fold desc="Offer">
//Get all Offers
self.GetAllOffers = function (userUUID, callback) {
    db.func('GetAllOffers', [userUUID])
        .then(function (data) {
            callback(null, data);
        })
        .catch(function (error) {
            logger.crit(error);
            callback(error);
        });
};

//Get Offer by ID
self.GetOfferByID = function (userUUID, offerUUID, callback) {
    db.func('GetOfferByID', [offerUUID, userUUID])
        .then(function (data) {
            callback(null, data)
        })
        .catch(function (error) {
            logger.crit(error);
            callback(error);
        });
};

//Get Offer for Request
self.GetOfferForRequest = function (userUUID, offerRequestUUID, callback) {
    db.func('GetOfferByRequestID', [offerRequestUUID, userUUID])
        .then(function (data) {
            callback(null, data);
        })
        .catch(function (error) {
            logger.crit(error);
            callback(error);
        });
};

//Get Offer for Request
self.GetOfferForPaymentInvoice = function (userUUID, paymentInvoiceUUID, callback) {
    db.func('GetOfferForPaymentInvoice', [paymentInvoiceUUID, userUUID])
        .then(function (data) {
            callback(null, data);
        })
        .catch(function (error) {
            logger.crit(error);
            callback(error);
        });
};

//Get Offer for Request
self.GetOfferForTransaction = function (userUUID, transactionUUID, callback) {
    db.func('GetOfferForTransaction', [transactionUUID, userUUID])
        .then(function (data) {
            //Only return the first element
            if (data && data.length) {
                data = data[0];
            }
            callback(null, data);
        })
        .catch(function (error) {
            logger.crit(error);
            callback(error);
        });
};
//</editor-fold>

//<editor-fold desc="OfferRequestBody">
self.CreateOfferRequest = function (userUUID, requestData, callback) {
    logger.debug('User UUID: ' +  userUUID);
    //TODO: A request should have more than one item
    db.func('CreateOfferRequest',
        [   requestData.items[0].dataId,
            requestData.items[0].amount,
            requestData.hsmId,
            userUUID,
            userUUID //TODO: what is the buyer uuid?
        ])
        .then(function (data) {
            logger.debug(data);
            callback(null, data);
        })
        .catch(function (error) {
            logger.crit(error);
            callback(error);
        });
};

//</editor-fold>

//<editor-fold desc="Payment">
// GetPaymentForOfferRequest
self.GetPaymentInvoiceForOfferRequest = function(userUUID, offerRequestUUID, callback){
    db.func('GetPaymentInvoiceForOfferRequest', [offerRequestUUID, userUUID])
        .then(function (data) {
            callback(null, data);
        })
        .catch(function (error) {
            logger.crit(error);
            callback(error);
        });
};

self.SetPayment = function(userUUID, payment, callback) {
    db.func('SetPayment', [payment.transactionUUID, payment.bitcoinTransaction, payment.confidenceState, payment.depth, payment.extInvoiceId, userUUID])
        .then(function (data) {
            if (data && data.length) {
                data = data[0];
            }
            logger.debug('SetPayment result: ' + JSON.stringify(data));
            callback(null, data);
        })
        .catch(function (error) {
            logger.crit(error);
            callback(error);
        });
};
//</editor-fold>

//<editor-fold desc="PaymentInvoice">
//</editor-fold>

//<editor-fold desc="Offer and Invoice">
self.SetPaymentInvoiceOffer = function (userUUID, invoice, offerRequestUUID, callback) {
    db.func('SetPaymentInvoiceOffer',
        [   offerRequestUUID,
            invoice,
            userUUID
        ])
        .then(function (data) {
            logger.debug('SetPaymentInvoiceOffer result: ' + JSON.stringify(data));
            callback(null, data);
        })
        .catch(function (error) {
            logger.crit(error);
            callback(error);
        });
};
//</editor-fold>

//<editor-fold desc="Transactions">
//Get all transaction by given OfferRequest
self.GetTransactionByOfferRequest = function (userUUID, offerRequestUUID, callback) {
    db.func('GetTransactionByOfferRequest', [offerRequestUUID, userUUID])
        .then(function (data) {
            callback(null, data);
        })
        .catch(function (error) {
            logger.crit(error);
            callback(error);
        });
};

//Get all transaction by given OfferRequest
self.GetTransactionByID = function (userUUID, transactionUUID, callback) {
    db.func('GetTransactionByID', [transactionUUID, userUUID])
        .then(function (data) {
            if (data && data.length) {
                data = data[0];
            }
            callback(null, data);
        })
        .catch(function (error) {
            logger.crit(error);
            callback(error);
        });
};
//</editor-fold>

//<editor-fold desc="Tags">
//Get Tag for given technologydata
//TODO: Implementation
self.GetTagsForTechnologyData = function (userUUID, data, callback){
        db.func('GetTagsForTechnologyData', [data, userUUID])
            .then(function (data) {
                callback(null, data);
            })
            .catch(function (error) {
                logger.crit(error);
                callback(error);
            });
};
//</editor-fold>

//<editor-fold desc="Reports">
self.GetActivatedLicensesSince = function (userUUID, sinceDate, callback) {
    db.func('GetActivatedLicensesSince',[sinceDate, userUUID])
        .then(function (data) {
            logger.debug(data);
            callback(null, data);
        })
        .catch(function (error) {
            logger.crit(error);
            callback(error);
        });
};

self.GetTopTechnologyDataSince = function(userUUID, sinceDate, topValue, callback){
    db.func('GetTopTechnologyDataSince', [sinceDate, topValue, userUUID])
        .then(function (data) {
            logger.debug(data);
            callback(null, data);
        })
        .catch(function (error) {
            logger.crit(error);
            callback(error);
        });
};

self.GetWorkloadSince = function(userUUID, sinceDate, callback){
    db.func('GetWorkloadSince', [sinceDate, userUUID])
        .then(function (data) {
            logger.debug(data);
            callback(null, data);
        })
        .catch(function (error) {
            logger.crit(error);
            callback(error);
        });
};

self.GetMostUsedComponents = function(userUUID, sinceDate, topValue, callback){
    db.func('GetMostUsedComponents', [sinceDate, topValue, userUUID])
        .then(function (data) {
            logger.debug(data);
            callback(null, data);
        })
        .catch(function (error) {
            logger.crit(error);
            callback(error);
        });
};

self.GetRevenuePerHour = function(userUUID, sinceDate, callback){
    db.func('GetRevenuePerHourSince', [sinceDate, userUUID])
        .then(function (data) {
            logger.debug(data);
            callback(null, data);
        })
        .catch(function (error) {
            logger.crit(error);
            callback(error);
        });
};

self.GetRevenuePerDay = function(userUUID, sinceDate, callback){
    db.func('GetRevenuePerDaySince', [sinceDate, userUUID])
        .then(function (data) {
            logger.debug(data);
            callback(null, data);
        })
        .catch(function (error) {
            logger.crit(error);
            callback(error);
        });
};
//</editor-fold>



//<editor-fold desc="License">

self.CreateLicenseOrder = function(ticketId, offerUUID, userUUID, callback) {
    db.func('CreateLicenseOrder', [ticketId, offerUUID, userUUID])
        .then(function (data) {
            if (data && data.length) {
                data = data[0];
            }

            logger.debug('CreateLicenseOrder result: ' + JSON.stringify(data));
            callback(null, data);
        })
        .catch(function (error) {
            logger.crit(error);
            callback(error);
        });
};

//</editor-fold>
module.exports = self;