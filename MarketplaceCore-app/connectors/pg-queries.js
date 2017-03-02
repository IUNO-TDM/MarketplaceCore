/* ##########################################################################
 -- Author: Marcel Ely Gomes
 -- Company: Trumpf Werkzeugmaschine GmbH & Co KG
 -- CreatedAt: 2017-02-27
 -- Description: Wrapped the database connection and define all database functions according to the DB Interface
 -- This script works with PostgreSQL databases
 -- ##########################################################################*/

var pgp = require('pg-promise')();
var db = pgp("postgres://postgres:Trumpf1234@192.168.8.101:5432/marketplacecore");

var self = {};


//<editor-fold desc="Users">
// GetAllUsers(userUUid)
// GetUserByID(requestUserUUDID,userUUid)
//</editor-fold>

//<editor-fold desc="TechnologyData">
// GetAllTechnologyData
self.GetAllTechnologyData = function (userUUID, callback) {
    db.func('GetAllTechnologyData')
        .then(function (data) {
            callback(null, data)
        })
        .catch(function (error) {
            console.log("ERROR:", error.message || error); // print the error;
            callback(error);
        });
};

self.GetTechnologyDataByID = function (userUUID, dataId, callback) {

    db.func('GetTechnologyDataByID', [dataId, userUUID])
        .then(function (data) {
            callback(null, data);
        })
        .catch(function (error) {
            console.log("ERROR:", error.message || error); // print the error;
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
        [userUUID,
            technologyData,
            technologies,
            tags,
            components,
            attributes
        ]
    )
        .then(function (data) {
            console.log(data);
            callback(null, data);
        })
        .catch(function (error) {
            console.log("ERROR:", error.message || error); // print the error;
            callback(error);
        });
};

//GetTechnologyDataByName
self.GetTechnologyDataByName = function (userUUID, name, callback) {
    db.func('GetTechnologyDataByName', [name, userUUID])
        .then(function (data) {
            console.log(data);
            callback(null, data);
        })
        .catch(function (error) {
            console.log("ERROR:", error.message || error); // print the error;
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
            console.log(data);
            callback(null, data);
        })
        .catch(function (error) {
            console.log("ERROR:", error.message || error); // print the error;
            callback(error);
        });
};

//</editor-fold>

//<editor-fold desc="Technologies">
//Get all Technologies
self.GetAllTechnologies = function (req, res, next) {
    var userUUID = req.query['userUUID'];
    db.func('GetAllTechnologies')
        .then(function (data) {
            res.json(data);
        })
        .catch(function (error) {
            console.log("ERROR:", error.message || error); // print the error;
        });
};

//Get technology by ID
self.GetTechnologyByID = function (req, res, next) {
    var userUUID = req.query['userUUID'];
    var technologyUUID = req.params['technologyUUID'];
    db.func('GetTechnologyByID', [technologyUUID])
        .then(function (data) {
            res.json(data);
        })
        .catch(function (error) {
            console.log("ERROR:", error.message || error); // print the error;
        });
};

//Get technology by name
self.GetTechnologyByName = function (req, res, next) {
    var userUUID = req.query['userUUID'];
    var technologyName = req.params['technologyName'];
    db.func('GetTechnologyByName', [technologyName])
        .then(function (data) {
            res.json(data);
        })
        .catch(function (error) {
            console.log("ERROR:", error.message || error); // print the error;
        });
};

//Get technology by name
self.CreateTechnology = function (req, res, next) {
    var userUUID = req.query['userUUID'];
    var technologyName = req.query['technologyName'];
    var technologyDescription = req.query['technologyDescription'];

    db.func('CreateTechnology',
        [
            technologyName,
            technologyDescription,
            userUUID
        ])
        .then(function (data) {
            res.json(data);
        })
        .catch(function (error) {
            console.log("ERROR:", error.message || error); // print the error;
        });
};
//</editor-fold>

//<editor-fold desc="Components">
//Get all GetAllComponents
self.GetAllComponents = function (req, res, next) {
    var userUUID = req.query['userUUID'];
    db.func('GetAllComponents')
        .then(function (data) {
            res.json(data);
        })
        .catch(function (error) {
            console.log("ERROR:", error.message || error); // print the error;
        });
};

//Get component by ID
self.GetComponentByID = function (req, res, next) {
    var userUUID = req.query['userUUID'];
    var componentUUID = req.params['componentUUID'];
    db.func('GetComponentByID', [componentUUID])
        .then(function (data) {
            res.json(data);
        })
        .catch(function (error) {
            console.log("ERROR:", error.message || error); // print the error;
        });
};

//Get component by name
self.GetComponentByName = function (req, res, next) {
    var userUUID = req.query['userUUID'];
    var componentName = req.params['componentName'];
    db.func('GetComponentByName', [componentName])
        .then(function (data) {
            res.json(data);
        })
        .catch(function (error) {
            console.log("ERROR:", error.message || error); // print the error;
        });
};

//Create component
self.SetComponent = function (req, res, next) {
    var userUUID = req.query['userUUID'];
    var componentName = req.query['componentName'];
    var componentDescription = req.query['componentDescription'];
    var componentParentName = req.query['componentParentName'];
    var attributeList = req.query['attributeList'];
    var technologyList = req.query['technologyList'];

    db.func('SetComponent',
        [
            componentName,
            componentParentName,
            componentDescription,
            attributeList,
            technologyList,
            userUUID
        ])
        .then(function (data) {
            res.json(data);
        })
        .catch(function (error) {
            console.log("ERROR:", error.message || error); // print the error;
        });
};
//</editor-fold>

//<editor-fold desc="Attributes">
//Get all Technologies
self.GetAllAttributes = function (req, res, next) {
    var userUUID = req.query['userUUID'];
    db.func('GetAllAttributes')
        .then(function (data) {
            res.json(data);
        })
        .catch(function (error) {
            console.log("ERROR:", error.message || error); // print the error;
        });
};

//Get technology by ID
self.GetAttributeByID = function (req, res, next) {
    var userUUID = req.query['userUUID'];
    var attributeUUID = req.params['attributeUUID'];
    db.func('GetAttributeByID', [attributeUUID])
        .then(function (data) {
            res.json(data);
        })
        .catch(function (error) {
            console.log("ERROR:", error.message || error); // print the error;
        });
};

//Get technology by name
self.GetAttributeByName = function (req, res, next) {
    var userUUID = req.query['userUUID'];
    var attributeName = req.params['attributeName'];
    db.func('GetAttributeByName', [attributeName])
        .then(function (data) {
            res.json(data);
        })
        .catch(function (error) {
            console.log("ERROR:", error.message || error); // print the error;
        });
};

//Get technology by name
self.CreateAttribute = function (req, res, next) {
    var userUUID = req.query['userUUID'];
    var attributeName = req.query['attributeName'];

    db.func('CreateAttribute',
        [
            attributeName,
            userUUID
        ])
        .then(function (data) {
            res.json(data);
        })
        .catch(function (error) {
            console.log("ERROR:", error.message || error); // print the error;
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
            console.log("ERROR:", error.message || error); // print the error;
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
            console.log("ERROR:", error.message || error); // print the error;
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
            console.log("ERROR:", error.message || error); // print the error;
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
            console.log("ERROR:", error.message || error); // print the error;
            callback(error);
        });
};

//Create Offer
self.CreateOffer = function (userUUID, params, callback) {

    db.func('CreateOffer',
        [
            userUUID
        ])
        .then(function (data) {
            callback(null, data);
        })
        .catch(function (error) {
            console.log("ERROR:", error.message || error); // print the error;
            callback(error);
        });
};
//</editor-fold>

//<editor-fold desc="OfferRequestBody">
//</editor-fold>

//<editor-fold desc="Payment">
//</editor-fold>

//<editor-fold desc="PaymentInvoice">
//</editor-fold>

//<editor-fold desc="Transactions">
//</editor-fold>

//<editor-fold desc="LicenseOrder">
//</editor-fold>

//<editor-fold desc="LicenseOrder">
//</editor-fold>

//<editor-fold desc="Tags">
//</editor-fold>

//<editor-fold desc="Misc">
//</editor-fold>

module.exports = self;