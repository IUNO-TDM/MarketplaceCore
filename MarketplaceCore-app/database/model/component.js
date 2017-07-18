/**
 * Created by beuttlerma on 31.05.17.
 */

var logger = require('../../global/logger');
var db = require('../db_connection');

/**
 *
 * Builds a component object from a database response
 *
 * @param data
 * @constructor
 */
function Component(data) {
    if (data) {
        this.componentuuid = data.componentuuid;
        this.componentname = data.componentname;
        this.componentparentid = data.componentparentid;
        this.componentparentname = data.componentparentname;
        this.componentdescription = data.componentdescription;
        this.createdat = data.createdat;
        this.createdby = data.createdby;
        this.updatedat = data.updatedat;
        this.useruuid = data.useruuid;
        this.attributelist = data.attributelist;
        this.technologylist = data.technologylist;

        console.log(data);
    }

}

Component.prototype.FindAll = Component.FindAll = function (userUUID, roleName, params, callback) {
    db.func('GetAllComponents', [roleName])
        .then(function (data) {
            var resultList = [];

            for (var key in data) {
                resultList.push(new Component(data[key]));
            }

            callback(null, resultList);
        })
        .catch(function (error) {
            logger.crit(error);
            callback(error);
        });
};

Component.prototype.FindSingle = Component.FindSingle = function (userUUID, roleName, id, callback) {
    db.func('GetComponentByID', [id, roleName])
        .then(function (data) {
            if (data && data.length) {
                data = data[0];
            }
            callback(null, new Component(data));
        })
        .catch(function (error) {
            logger.crit(error);
            callback(error);
        });
};

Component.prototype.FindByTechnologyDataId =  Component.FindByTechnologyDataId = function (userUUID, technologyDataId, callback) {
    db.func('GetComponentsForTechnologyDataId', [technologyDataId, userUUID])
        .then(function (data) {
            var resultList = [];
            for (var key in data) {
                resultList.push(new Component(data[key]));
            }
            callback(null, resultList);
        })
        .catch(function (error) {
            logger.crit(error);
            callback(error);
        });
};

Component.prototype.Create = function (userUUID, rolename, callback) {
    db.func('SetComponent',
        [   this.componentname,
            this.componentparentname,
            this.componentdescription,
            this.attributelist,
            this.technologylist,
            userUUID,
            rolename
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

Component.prototype.Update = function () {
    throw {name: "NotImplementedError", message: "Function not implemented yet"}; //TODO: Implement this function if needed
};

Component.prototype.Delete = function () {
    throw {name: "NotImplementedError", message: "Function not implemented yet"}; //TODO: Implement this function if needed
};

module.exports = Component;