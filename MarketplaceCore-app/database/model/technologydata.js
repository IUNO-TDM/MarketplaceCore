/**
 * Created by beuttlerma on 14.03.17.
 */
var logger = require('../../global/logger');
var db = require('../db_connection');

/**
 * Creates an technologydata object from a database query result.
 *
 * @constructor
 */
function TechnologyData(data) {
    this.SetProperties(data);
}

TechnologyData.prototype.SetProperties = function (data) {
    if (data) {
        this.technologydataid = data.technologydataid ? data.technologydataid : this.technologydataid;
        this.technologydatauuid = data.technologydatauuid ? data.technologydatauuid : this.technologydatauuid;
        this.technologydataname = data.technologydataname ? data.technologydataname : this.technologydataname;
        this.technologyuuid = data.technologyuuid ? data.technologyuuid : this.technologyuuid;
        this.technologydata = data.technologydata ? data.technologydata : this.technologydata;
        this.licensefee = data.licensefee ? data.licensefee : this.licensefee;
        this.productcode = data.productcode ? data.productcode : this.productcode;
        this.technologydatadescription = data.technologydatadescription ? data.technologydatadescription : this.technologydatadescription;
        this.createdat = data.createdat ? data.createdat : this.createdat;
        this.createdby = data.createdby ? data.createdby : this.createdby;
        this.updatedat = data.updatedat ? data.updatedat : this.updatedat;
        this.updatedby = data.updatedby ? data.updatedby : this.updatedby;
        this.componentlist = data.componentlist ? data.componentlist : this.componentlist;
        this.taglist = data.taglist ? data.taglist : this.taglist;
    }
};

TechnologyData.prototype.FindAll = TechnologyData.FindAll = function (userUUID, roles, params, callback) {
    var technologies = params['technologies'];
    var tags = params['tags'];
    var components = params['components'];
    var attributes = params['attributes'];
    var technologydataname = params['technologydataname'];
    var ownerUUID = params['ownerUUID'];


    db.func('GetTechnologyDataByParams',
        [components,
            technologies,
            technologydataname,
            ownerUUID,
            userUUID,
            roles
        ], 1 //TODO: Document this parameter
    )
        .then(function (data) {
            logger.debug('Database query result: ' + JSON.stringify(data));
            var resultList = [];
            for (var key in data.result) {
                resultList.push(new TechnologyData(data.result[key]));
            }
            callback(null, resultList);
        })
        .catch(function (error) {
            logger.crit(error);
            callback(error);
        });
};

TechnologyData.prototype.FindSingle = TechnologyData.FindSingle = function (userUUID, roles, id, callback) {
    db.func('GetTechnologyDataByID', [id, userUUID, roles])
        .then(function (data) {
            //Only return the first element
            if (data && data.length) {
                data = data[0];
            }

            callback(null, new TechnologyData(data));
        })
        .catch(function (error) {
            logger.crit(error); // print the error;
            callback(error);
        });
};
TechnologyData.prototype.Create = function (userUUID, roles, callback) {
    const self = this;
    db.func('SetTechnologyData',
        [this.technologydataname,
            this.technologydata,
            this.technologydatadescription,
            this.technologyuuid,
            this.licensefee,
            this.productcode,
            this.taglist ? this.taglist : [''],
            this.componentlist,
            userUUID,
            roles
        ])
        .then(function (data) {
            if (data && data.length) {
                data = data[0];
            }
            logger.debug(data);
            self.SetProperties(data);

            callback(null, self);
        })
        .catch(function (error) {
            logger.crit(error);
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