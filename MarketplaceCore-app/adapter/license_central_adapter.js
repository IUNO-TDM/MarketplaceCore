

let self = require('./license_central_strategy/default');

try {
    self = require('./license_central_strategy/' + process.env.NODE_ENV);
}
catch (err) {

}

module.exports = self;