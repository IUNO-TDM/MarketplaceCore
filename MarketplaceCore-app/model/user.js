/**
 * Created by beuttlerma on 14.03.17.
 */

var logger = require('../global/logger');
var pgp = require('pg-promise')();
var connectionString = require('../config/private_config_local').connectionString;
var db = pgp(connectionString);

function User(data) {
    this.userid = data.userid;
    this.useruuid = data.useruuid;
    this.userfirstname = data.userfirstname;
    this.userlastname = data.userlastname;
    this.useremail = data.useremail;
    this.thumbnail = data.thumbnail;
    this.imgpath = data.imgpath;
    this.createdat = data.createdat;
    this.updatedat = data.updatedat;

}

User.prototype.FindAll = function (callback) {
    db.func('GetAllUsers')
        .then(function (data) {
            var resultList = [];
            for (var key in data) {
                resultList.push(new User(data[key]));
            }
            callback(null, resultList)
        })
        .catch(function (error) {
            logger.debug("ERROR:", error.message || error); // print the error;
            callback(error);
        });
};

User.prototype.FindSingle = function (id, callback) {
    db.func('GetUserByID', [id])
        .then(function (data) {
            //Only return the first element
            if (data && data.length) {
                data = data[0];
            }
            callback(null, new User(data));
        })
        .catch(function (error) {
            logger.debug("ERROR:", error.message || error); // print the error;
            callback(error);
        });
};
User.prototype.Create = function () {
    db.func('CreateUser', [this.userfirstname, this.userlastname, this.useremail])
        .then(function (data) {
            callback(null, new User(data));
        })
        .catch(function (error) {
            logger.debug("ERROR:", error.message || error); // print the error;
            callback(error);
        });
};
User.prototype.Update = function () {
    throw {name: "NotImplementedError", message: "Function not implemented yet"}; //TODO: Implement this function if needed
};
User.prototype.Delete = function () {
    throw {name: "NotImplementedError", message: "Function not implemented yet"}; //TODO: Implement this function if needed
};

module.exports = User;