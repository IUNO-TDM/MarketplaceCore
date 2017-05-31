/**
 * Created by beuttlerma on 14.03.17.
 */

var logger = require('../global/logger');
var db = require('../global/database').db;

/**
 *
 * Builds a user object from a database response
 *
 * @param data
 * @constructor
 */
function User(data) {
    if (data) {
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
}

User.prototype.FindAll = function () {
    throw {name: "NotImplementedError", message: "Function not implemented yet"}; //TODO: Implement this function if needed
};

User.prototype.FindSingle = function (userUUID, id, callback) {

    db.func('GetUserByID', [id, userUUID])
        .then(function (data) {
            //Only return the first element
            if (data && data.length) {
                data = data[0];
            }
            callback(null, new User(data))
        })
        .catch(function (error) {
            logger.crit(error);
            callback(error);
        });
};

User.prototype.Create = function (userUUID, callback) {
    db.func('CreateUser', [this.userfirstname, this.userlastname, this.useremail, userUUID])
        .then(function (data) {
            callback(null, new User(data));
        })
        .catch(function (error) {
            logger.crit("ERROR:", error.message || error); // print the error;
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