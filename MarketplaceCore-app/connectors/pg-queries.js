/* ##########################################################################
 -- Author: Marcel Ely Gomes
 -- Company: Trumpf Werkzeugmaschine GmbH & Co KG
 -- CreatedAt: 2017-02-27
 -- Description: Wrapped the database connection and define all database functions according to the DB Interface
 -- This script works with PostgreSQL databases
 -- ##########################################################################*/

var logger = require('../global/logger');
var pgp = require('pg-promise')();
var connectionString = require('../config/private_config_local').connectionString;
var db = pgp(connectionString);

var self = {};


//<editor-fold desc="Users">
// GetAllUsers(userUUID)
self.GetAllUsers = function (userUUID, callback) {
    db.func('GetAllUsers')
        .then(function (data) {
            callback(null, data)
        })
        .catch(function (error) {
            logger.debug("ERROR:", error.message || error); // print the error;
            callback(error);
        });
};

// GetUserByID(userUUID, dataId)
self.GetUserByID = function (userUUID, callback) {
    db.func('GetUserByID', [userUUID])
        .then(function (data) {
            //Only return the first element
            if (data && data.length) {
                data = data[0];
            }
            callback(null, data)
        })
        .catch(function (error) {
            logger.debug("ERROR:", error.message || error); // print the error;
            callback(error);
        });
};

// GetUserByID(userUUID, firstName, lastName)
self.GetUserByName = function (userUUID, firstName, lastName, callback) {
    db.func('GetUserByName', [firstName, lastName])
        .then(function (data) {
            //Only return the first element
            //TODO: Correction has to be made. It's is possible to have many users with the same name, e.g. Michael Mueller
            if (data && data.length) {
                data = data[0];
            }
            callback(null, data)
        })
        .catch(function (error) {
            logger.debug("ERROR:", error.message || error); // print the error;
            callback(error);
        });
};

// CreateUser(userUUID, firstName, lastName, email)
self.CreateUser = function (userUUID, data, callback) {

    var firstName = data['firstName'];
    var lastName = data['lastName'];
    var emailAddress = data['emailAddress'];
    db.func('CreateUser', [firstName, lastName, emailAddress])
        .then(function (data) {
            callback(null, data)
        })
        .catch(function (error) {
            logger.debug("ERROR:", error.message || error); // print the error;
            callback(error);
        });
};

//</editor-fold>

//<editor-fold desc="TechnologyData">
// GetAllTechnologyData
self.GetAllTechnologyData = function (userUUID, callback) {
    db.func('GetAllTechnologyData')
        .then(function (data) {
            callback(null, data)
        })
        .catch(function (error) {
            logger.debug("ERROR:", error.message || error); // print the error;
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
            logger.crit("ERROR:", error.message || error); // print the error;
            callback(error);
        });
};

//Get TechnologyDataByParams
self.GetTechnologyDataByParams = function (userUUID, params, callback) {
    var technologies = params['technologies'];
    var technologyData = params['technologyData'];
    var tags = params['tags'];
    var components = params['components'];
    var attributes = params['attributes'];

    db.func('GetTechnologyDataByParams',
        [   userUUID,
            technologyData,
            technologies,
            tags,
            components,
            attributes
        ]
    )
        .then(function (data) {
            logger.debug(JSON.stringify(data));
            callback(null, data);
        })
        .catch(function (error) {
            logger.crit("ERROR:", error.message || error); // print the error;
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
            logger.crit("ERROR:", error.message || error); // print the error;
            callback(error);
        });
};

//GetTechnologyDataByName
self.GetTechnologyDataByOfferRequest = function (userUUID, offerRequestUUID, callback) {

    db.func('GetTechnologyDataByOfferRequest', [offerRequestUUID])
        .then(function (data) {
            callback(null, data)
        })
        .catch(function (error) {
            logger.debug("ERROR:", error.message || error); // print the error;
            callback(error);
        });
};

//Get all transaction by given OfferRequest
self.GetLicenseFeeByTransaction = function (userUUID, transactionUUID, callback) {
    db.func('GetLicenseFeeByTransaction', [transactionUUID])
        .then(function (data) {
            callback(null, data);
        })
        .catch(function (error) {
            logger.crit("ERROR:", error.message || error); // print the error;
            callback(error);
        });
};

self.SetTechnologyData = function (userUUID, data, callback) {
    var technologyDataName = data['technologyDataName'];
    var technologyData = data['technologyData'];
    var technologyDataDescription = data['technologyDataDescription'];
    var technologyUUID = data['technologyUUID'];
    var licenseFee = data['licenseFee'];
    var tagList = data['tagList'];
    var componentList = data['componentList'];

    db.func('SetTechnologyData',
        [technologyDataName,
            technologyData,
            technologyDataDescription,
            technologyUUID,
            licenseFee,
            tagList,
            userUUID,
            componentList
        ])
        .then(function (data) {
            logger.debug(data);
            callback(null, data);
        })
        .catch(function (error) {
            logger.crit("ERROR:", error.message || error); // print the error;
            callback(error);
        });
};

//</editor-fold>

//<editor-fold desc="Technologies">
//Get all Technologies
self.GetAllTechnologies = function (userUUID, callback) {

    db.func('GetAllTechnologies')
        .then(function (data) {
            callback(null, data)
        })
        .catch(function (error) {
            logger.debug("ERROR:", error.message || error); // print the error;
            callback(error);
        });
};

//Get technology by ID
self.GetTechnologyByID = function (userUUID, technologyUUID, callback) {

    db.func('GetTechnologyByID', [technologyUUID])
        .then(function (data) {
            callback(null, data);
        })
        .catch(function (error) {
            logger.crit("ERROR:", error.message || error); // print the error;
            callback(error);
        });
};

//Get technology by OfferRequest
self.GetTechnologyForOfferRequest = function (userUUID, offerRequestUUID, callback) {

    db.func('GetTechnologyForOfferRequest', [offerRequestUUID])
        .then(function (data) {
            callback(null, data);
        })
        .catch(function (error) {
            logger.crit("ERROR:", error.message || error); // print the error;
            callback(error);
        });
};

self.GetComponentByID = function (userUUID, componentUUID, callback) {

    db.func('GetComponentByID', [componentUUID])
        .then(function (data) {
            callback(null, data);
        })
        .catch(function (error) {
            logger.crit("ERROR:", error.message || error); // print the error;
            callback(error);
        });
};

//Get Component by Name
self.GetComponentByName = function (userUUID, componentName, callback) {

    db.func('GetComponentByName', [componentName])
        .then(function (data) {
            callback(null, data);
        })
        .catch(function (error) {
            logger.crit("ERROR:", error.message || error); // print the error;
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
                logger.crit("ERROR:", error.message || error); // print the error;
                callback(error);
            });
    };
//</editor-fold>

//<editor-fold desc="Components">
//Get all GetAllComponents
self.GetAllComponents = function (userUUID, callback) {

    db.func('GetAllComponents')
        .then(function (data) {
            callback(null, data)
        })
        .catch(function (error) {
            logger.debug("ERROR:", error.message || error); // print the error;
            callback(error);
        });
};

//Get Component by ID
self.GetComponentByID = function (userUUID, componentUUID, callback) {

    db.func('GetComponentByID', [componentUUID])
        .then(function (data) {
            callback(null, data);
        })
        .catch(function (error) {
            logger.crit("ERROR:", error.message || error); // print the error;
            callback(error);
        });
};

//Get Component by Name
self.GetComponentByName = function (userUUID, componentName, callback) {

    db.func('GetComponentByName', [componentName])
        .then(function (data) {
            callback(null, data);
        })
        .catch(function (error) {
            logger.crit("ERROR:", error.message || error); // print the error;
            callback(error);
        });
};

//Get Component by Technology
self.GetComponentsByTechnology = function (userUUID, technologyUUID, callback) {

    db.func('GetComponentsByTechnology', [technologyUUID])
        .then(function (data) {
            callback(null, data);
        })
        .catch(function (error) {
            logger.crit("ERROR:", error.message || error); // print the error;
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
            logger.crit("ERROR:", error.message || error); // print the error;
            callback(error);
        });
};
//</editor-fold>

//<editor-fold desc="Attributes">
//Get all GetAllAttributes
self.GetAllAttributes = function (userUUID, callback) {

    db.func('GetAllAttributes')
        .then(function (data) {
            callback(null, data)
        })
        .catch(function (error) {
            logger.debug("ERROR:", error.message || error); // print the error;
            callback(error);
        });
};

//Get Attribute by ID
self.GetAttributeByID = function (userUUID, attributeUUID, callback) {

    db.func('GetAttributeByID', [attributeUUID])
        .then(function (data) {
            callback(null, data);
        })
        .catch(function (error) {
            logger.crit("ERROR:", error.message || error); // print the error;
            callback(error);
        });
};

//Get Attribute by Name
self.GetAttributeByName = function (userUUID, attributeName, callback) {

    db.func('GetAttributeByName', [attributeName])
        .then(function (data) {
            callback(null, data);
        })
        .catch(function (error) {
            logger.crit("ERROR:", error.message || error); // print the error;
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
            logger.crit("ERROR:", error.message || error); // print the error;
            callback(error);
        });
};
//</editor-fold>

//<editor-fold desc="Offer">
//Get all Offers
self.GetAllOffers = function (userUUID, callback) {
    db.func('GetAllOffers')
        .then(function (data) {
            callback(null, data);
        })
        .catch(function (error) {
            logger.crit("ERROR:", error.message || error); // print the error;
            callback(error);
        });
};

//Get Offer by ID
self.GetOfferByID = function (userUUID, offerUUID, callback) {
    db.func('GetOfferByID', [offerUUID])
        .then(function (data) {
            callback(null, data)
        })
        .catch(function (error) {
            logger.crit("ERROR:", error.message || error); // print the error;
            callback(error);
        });
};

//Get Offer for Request
self.GetOfferForRequest = function (userUUID, offerRequestUUID, callback) {
    db.func('GetOfferByRequestID', [offerRequestUUID])
        .then(function (data) {
            callback(null, data);
        })
        .catch(function (error) {
            logger.crit("ERROR:", error.message || error); // print the error;
            callback(error);
        });
};

//Get Offer for Request
self.GetOfferForPaymentInvoice = function (userUUID, paymentInvoiceUUID, callback) {
    db.func('GetOfferForPaymentInvoice', [paymentInvoiceUUID])
        .then(function (data) {
            callback(null, data);
        })
        .catch(function (error) {
            logger.crit("ERROR:", error.message || error); // print the error;
            callback(error);
        });
};

//Get Offer for Request
self.GetOfferForTransaction = function (userUUID, transactionUUID, callback) {
    db.func('GetOfferForTransaction', [transactionUUID])
        .then(function (data) {
            callback(null, data);
        })
        .catch(function (error) {
            logger.crit("ERROR:", error.message || error); // print the error;
            callback(error);
        });
};
//</editor-fold>

//<editor-fold desc="OfferRequestBody">
self.CreateOfferRequest = function (userUUID, requestData, callback) {
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
            logger.crit("ERROR:", error.message || error); // print the error;
            callback(error);
        });
};

//</editor-fold>

//<editor-fold desc="Payment">
// GetPaymentForOfferRequest
self.GetPaymentInvoiceForOfferRequest = function(userUUID, offerRequestUUID, callback){
    db.func('GetPaymentInvoiceForOfferRequest', [offerRequestUUID])
        .then(function (data) {
            callback(null, data);
        })
        .catch(function (error) {
            logger.crit("ERROR:", error.message || error); // print the error;
            callback(error);
        });
}
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
            logger.debug(data);
            callback(null, data);
        })
        .catch(function (error) {
            logger.debug("ERROR:", error.message || error); // print the error;
            callback(error);
        });
};
//</editor-fold>

//<editor-fold desc="Transactions">
//Get all transaction by given OfferRequest
self.GetTransactionByOfferRequest = function (userUUID, offerRequestUUID, callback) {
    db.func('GetTransactionByOfferRequest', [offerRequestUUID])
        .then(function (data) {
            callback(null, data);
        })
        .catch(function (error) {
            logger.crit("ERROR:", error.message || error); // print the error;
            callback(error);
        });
};
//</editor-fold>

//<editor-fold desc="Tags">
//Get Tag for given technologydata
//TODO: Implementation
self.GetTagsForTechnologyData = function (userUUID, data, callback){
        db.func('GetTagsForTechnologyData', [data])
            .then(function (data) {
                callback(null, data);
            })
            .catch(function (error) {
                logger.crit("ERROR:", error.message || error); // print the error;
                callback(error);
            });
};
//</editor-fold>

//<editor-fold desc="Reports">
self.GetActivatedLicensesSince = function (userUUID, sinceDate, callback) {
    db.func('GetActivatedLicensesSince',[sinceDate])
        .then(function (data) {
            logger.debug(data);
            callback(null, data);
        })
        .catch(function (error) {
            logger.debug("ERROR:", error.message || error); // print the error;
            callback(error);
        });
};

self.GetTopTechnologyDataSince = function(userUUID, sinceDate, topValue, callback){
    db.func('GetTopTechnologyDataSince', [sinceDate, topValue])
        .then(function (data) {
            logger.debug(data);
            callback(null, data);
        })
        .catch(function (error) {
            logger.debug("ERROR:", error.message || error); // print the error;
            callback(error);
        });
};

self.GetWorkloadSince = function(userUUID, sinceDate, callback){
    db.func('GetWorkloadSince', [sinceDate])
        .then(function (data) {
            logger.debug(data);
            callback(null, data);
        })
        .catch(function (error) {
            logger.debug("ERROR:", error.message || error); // print the error;
            callback(error);
        });
};

self.GetMostUsedComponents = function(userUUID, sinceDate, topValue, callback){
    db.func('GetMostUsedComponents', [sinceDate, topValue])
        .then(function (data) {
            logger.debug(data);
            callback(null, data);
        })
        .catch(function (error) {
            logger.debug("ERROR:", error.message || error); // print the error;
            callback(error);
        });
};
//</editor-fold>

module.exports = self;