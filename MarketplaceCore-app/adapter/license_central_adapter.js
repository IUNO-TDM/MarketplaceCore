

let self = {};

try {
    self = require('./license_central_strategy/' + process.env.NODE_ENV);
}
catch (err) {
    self = require('./license_central_strategy/default');
}

module.exports = self;