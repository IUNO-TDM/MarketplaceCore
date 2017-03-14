/**
 * Created by beuttlerma on 14.03.17.
 */
var logger = require('../global/logger');
var pgp = require('pg-promise')();
var connectionString = require('../config/private_config_local').connectionString;
var db = pgp(connectionString);

function TechnologyData(data) {
    this.technologydataid = data.technologydataid;
    this.technologydatauuid = data.technologydatauuid;
    this.technologydataname = data.technologydataname;
    this.technologyid = data.technologyid;
    this.technologydata = data.technologydata;
    this.licensefee = data.licensefee;
    this.retailprice = data.retailprice;
    this.licenseproductcode = data.licenseproductcode;
    this.technologydatadescription = data.technologydatadescription;
    this.technologydatathumbnail = data.technologydatathumbnail;
    this.technologydataimgref = data.technologydataimgref;
    this.createdat = data.createdat;
    this.createdby = data.createdby;
    this.updatedat = data.updatedat;
    this.updatedby = data.updatedby;
    this.componentlist = data.componentlist;
    this.taglist= data.taglist;
}

TechnologyData.prototype.FindAll = function (userUUID, params, callback) {
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
            logger.debug(JSON.stringify(data));
            var resultList = [];
            for (var key in data) {
                resultList.push(new TechnologyData(data[key]));
            }
            callback(null, resultList)
        })
        .catch(function (error) {
            logger.crit("ERROR:", error.message || error); // print the error;
            callback(error);
        });
};

TechnologyData.prototype.FindSingle = function (userUUID, id, callback) {
    db.func('GetTechnologyDataByID', [id, userUUID])
        .then(function (data) {
            //Only return the first element
            if (data && data.length) {
                data = data[0];
            }
            callback(null, new TechnologyData(data));
        })
        .catch(function (error) {
            logger.debug("ERROR:", error.message || error); // print the error;
            callback(error);
        });
};
TechnologyData.prototype.Create = function (userUUID) {
    db.func('SetTechnologyData',
        [this.technologydataname,
            this.technologydata,
            this.technologydatadescription,
            this.technologyid,
            this.licensefee,
            this.taglist,
            userUUID,
            this.componentlist
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
TechnologyData.prototype.Update = function () {
    throw {name: "NotImplementedError", message: "Function not implemented yet"}; //TODO: Implement this function if needed
};
TechnologyData.prototype.Delete = function () {
    throw {name: "NotImplementedError", message: "Function not implemented yet"}; //TODO: Implement this function if needed
};

module.exports = TechnologyData;