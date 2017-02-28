/* ##########################################################################
 -- Author: Marcel Ely Gomes
 -- Company: Trumpf Werkzeugmaschine GmbH & Co KG
 -- CreatedAt: 2017-02-27
 -- Description: Wrapped the database connection and define all database functions according to the DB Interface
 -- This script works with PostgreSQL databases
 -- ##########################################################################*/

var pgp = require('pg-promise')();
var db = pgp("postgres://postgres:Trumpf1234@localhost:5432/marketplacecore");

var self = {};




//<editor-fold desc="Users">
// GetAllUsers(userUUid)
// GetUserByID(requestUserUUDID,userUUid)
//</editor-fold>

//<editor-fold desc="TechnologyData">
// GetAllTechnologyData
self.GetAllTechnologyData = function(req, res, next)
{
    var userUUID = req.query['userUUID'];
    db.func('GetAllTechnologyData')
        .then(function(data) {
            res.json(data);
        })
        .catch(function (error) {
            console.log("ERROR:", error.message || error); // print the error;
        });
}

self.GetTechnologyDataByID = function(req, res, next)
{
    var userUUID = req.query['userUUID'];
    var TechnologyDataUUID = req.params['technologyDataUUID'];
    db.func('GetTechnologyDataByID',[TechnologyDataUUID, userUUID])
        .then(function(data) {
            res.json(data);
        })
        .catch(function (error) {
            console.log("ERROR:", error.message || error); // print the error;
        });
}

//Get TechnologyDataByParams
self.GetTechnologyDataByParams = function(req,res,next)
{
    var technologies = req.query['technologies'];
    var technologyData = req.query['technologyData'];
    var tags = req.query['tags'];
    var components = req.query['components'];
    var attributes = req.query['attributes'];
    var userUUID = req.query['userUUID']

    db.func('GetTechnologyDataByParams',
        [   userUUID,
            technologyData,
            technologies,
            tags,
            components,
            attributes
        ]
        )
        .then(function(data) {
            res.json(data);
            console.log(data);
        })
        .catch(function (error) {
            console.log("ERROR:", error.message || error); // print the error;
        });
}

//GetTechnologyDataByName
self.GetTechnologyDataByName = function(req,res,next)
{
    var technologyDataName = req.params['technologyDataName'];
    var userUUID = req.query['userUUID']
    db.func('GetTechnologyDataByName',[technologyDataName,userUUID])
        .then(function(data) {
            res.json(data);
            console.log(data);
        })
        .catch(function (error) {
            console.log("ERROR:", error.message || error); // print the error;
        });
}

self.SetTechnologyData = function(req,res,next)
{
    var technologyDataName = req.query['technologyDataName'];
    var technologyData = req.query['technologyData'];
    var technologyDataDescription = req.query['technologyDataDescription'];
    var technologyUUID = req.query['technologyUUID'];
    var licenseFee = req.query['licenseFee'];
    var tagList = req.query['tagList'];
    var componentList = req.query['componentList'];
    var userUUID = req.query['userUUID'];

    db.func('SetTechnologyData',
        [   technologyDataName,
            technologyData,
            technologyDataDescription,
            technologyUUID,
            licenseFee,
            tagList,
            userUUID,
            componentList
        ])
        .then(function(data) {
            res.json(data);
            console.log(data);
        })
        .catch(function (error) {
            console.log("ERROR:", error.message || error); // print the error;
        });
}

//</editor-fold>

//<editor-fold desc="Technologies">
//Get all Technologies
self.GetAllTechnologies = function(req, res, next)
{
    var userUUID = req.query['userUUID'];
    db.func('GetAllTechnologies')
        .then(function(data) {
            res.json(data);
        })
        .catch(function (error) {
            console.log("ERROR:", error.message || error); // print the error;
        });
}

//Get technology by ID
self.GetTechnologyByID = function(req, res, next)
{
    var userUUID = req.query['userUUID'];
    var technologyUUID = req.params['technologyUUID'];
    db.func('GetTechnologyByID',[technologyUUID])
        .then(function(data) {
            res.json(data);
        })
        .catch(function (error) {
            console.log("ERROR:", error.message || error); // print the error;
        });
}

//Get technology by name
self.GetTechnologyByName = function(req, res, next)
{
    var userUUID = req.query['userUUID'];
    var technologyName = req.params['technologyName'];
    db.func('GetTechnologyByName',[technologyName])
        .then(function(data) {
            res.json(data);
        })
        .catch(function (error) {
            console.log("ERROR:", error.message || error); // print the error;
        });
}

//Get technology by name
self.CreateTechnology =  function(req, res, next)
{
    var userUUID = req.query['userUUID'];
    var technologyName = req.query['technologyName'];
    var technologyDescription = req.query['technologyDescription'];

    db.func('CreateTechnology',
        [
            technologyName,
            technologyDescription,
            userUUID
        ])
        .then(function(data) {
            res.json(data);
        })
        .catch(function (error) {
            console.log("ERROR:", error.message || error); // print the error;
        });
}
//</editor-fold>

//<editor-fold desc="Components">
//Get all GetAllComponents
self.GetAllComponents =  function(req, res, next)
{
    var userUUID = req.query['userUUID'];
    db.func('GetAllComponents')
        .then(function(data) {
            res.json(data);
        })
        .catch(function (error) {
            console.log("ERROR:", error.message || error); // print the error;
        });
}

//Get component by ID
self.GetComponentByID = function(req, res, next)
{
    var userUUID = req.query['userUUID'];
    var componentUUID = req.params['componentUUID'];
    db.func('GetComponentByID',[componentUUID])
        .then(function(data) {
            res.json(data);
        })
        .catch(function (error) {
            console.log("ERROR:", error.message || error); // print the error;
        });
}

//Get component by name
self.GetComponentByName = function(req, res, next)
{
    var userUUID = req.query['userUUID'];
    var componentName = req.params['componentName'];
    db.func('GetComponentByName',[componentName])
        .then(function(data) {
            res.json(data);
        })
        .catch(function (error) {
            console.log("ERROR:", error.message || error); // print the error;
        });
}

//Create component
self.SetComponent = function(req, res, next)
{
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
        .then(function(data) {
            res.json(data);
        })
        .catch(function (error) {
            console.log("ERROR:", error.message || error); // print the error;
        });
}
//</editor-fold>

//<editor-fold desc="Attributes">
//Get all Technologies
self.GetAllAttributes = function(req, res, next)
{
    var userUUID = req.query['userUUID'];
    db.func('GetAllAttributes')
        .then(function(data) {
            res.json(data);
        })
        .catch(function (error) {
            console.log("ERROR:", error.message || error); // print the error;
        });
}

//Get technology by ID
self.GetAttributeByID = function(req, res, next)
{
    var userUUID = req.query['userUUID'];
    var technologyUUID = req.params['attributeUUID'];
    db.func('GetAttributeByID',[technologyUUID])
        .then(function(data) {
            res.json(data);
        })
        .catch(function (error) {
            console.log("ERROR:", error.message || error); // print the error;
        });
}

//Get technology by name
self.GetAttributeByName = function(req, res, next)
{
    var userUUID = req.query['userUUID'];
    var technologyName = req.params['attributeName'];
    db.func('GetAttributeByName',[technologyName])
        .then(function(data) {
            res.json(data);
        })
        .catch(function (error) {
            console.log("ERROR:", error.message || error); // print the error;
        });
}

//Get technology by name
self.CreateAttribute =  function(req, res, next)
{
    var userUUID = req.query['userUUID'];
    var attributeName = req.query['attributeName'];

    db.func('CreateAttribute',
        [
            attributeName,
            userUUID
        ])
        .then(function(data) {
            res.json(data);
        })
        .catch(function (error) {
            console.log("ERROR:", error.message || error); // print the error;
        });
}
//</editor-fold>

//<editor-fold desc="Offer">
//Get all Offers
self.GetAllOffers = function(req, res, next)
{
    var userUUID = req.query['userUUID'];
    db.func('GetAllOffers')
        .then(function(data) {
            res.json(data);
        })
        .catch(function (error) {
            console.log("ERROR:", error.message || error); // print the error;
        });
}

//Get Offer by ID
self.GetOfferByID = function(req, res, next)
{
    var userUUID = req.query['userUUID'];
    var technologyUUID = req.params['attributeUUID'];
    db.func('GetOfferByID',[technologyUUID])
        .then(function(data) {
            res.json(data);
        })
        .catch(function (error) {
            console.log("ERROR:", error.message || error); // print the error;
        });
}

//Get Offer for Request
self.GetOfferForRequest = function(req, res, next)
{
    var userUUID = req.query['userUUID'];
    var technologyName = req.params['attributeName'];
    db.func('GetOfferByRequest',[technologyName])
        .then(function(data) {
            res.json(data);
        })
        .catch(function (error) {
            console.log("ERROR:", error.message || error); // print the error;
        });
}

//Get Offer for Request
self.GetOfferForPaymentInvoice = function(req, res, next)
{
    var userUUID = req.query['userUUID'];
    var technologyName = req.params['attributeName'];
    db.func('GetOfferForPaymentInvoice',[technologyName])
        .then(function(data) {
            res.json(data);
        })
        .catch(function (error) {
            console.log("ERROR:", error.message || error); // print the error;
        });
}

//Create Offer
self.CreateOffer =  function(req, res, next)
{
    var userUUID = req.query['userUUID'];
    var attributeName = req.query['attributeName'];

    db.func('CreateOffer',
        [
            attributeName,
            userUUID
        ])
        .then(function(data) {
            res.json(data);
        })
        .catch(function (error) {
            console.log("ERROR:", error.message || error); // print the error;
        });
}
//</editor-fold>

//<editor-fold desc="OfferRequest">
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