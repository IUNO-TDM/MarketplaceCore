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


self.dosmth = function(){};

//<editor-fold desc="Users">
// GetAllUsers(userUUid)
// GetUserByID(requestUserUUDID,userUUid)
//</editor-fold>

//<editor-fold desc="TechnologyData">
// GetAllTechnologyData
function GetAllTechnologyData(req, res, next)
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

function GetTechnologyDataByID(req, res, next)
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
function GetTechnologyDataByParams(req,res,next)
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
function GetTechnologyDataByName(req,res,next)
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

function SetTechnologyData(req,res,next)
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
function GetAllTechnologies(req, res, next)
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
function GetTechnologyByID(req, res, next)
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
function GetTechnologyByName(req, res, next)
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
function CreateTechnology(req, res, next)
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
function GetAllComponents(req, res, next)
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
function GetComponentByID(req, res, next)
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
function GetComponentByName(req, res, next)
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
function SetComponent(req, res, next)
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

//</editor-fold>

//<editor-fold desc="Offer">
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