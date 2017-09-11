const fs = require('fs');
const path = require('path');
const config = require('../config/config_loader');
const logger = require('../global/logger');

const IMAGE_DIR = 'images/recipes/';
const DEFAULT_IMAGE = 'images/recipes/default.svg'

const self = {};

function randomInt (low, high) {
    return Math.floor(Math.random() * (high - low) + low);
}


self.getRandomImagePath = function () {
    try {
        const files = fs.readdirSync(IMAGE_DIR);

        const randomIndex = randomInt(0, files.length);

        return path.join(IMAGE_DIR, files[randomIndex]);
    }
    catch (err) {
        logger.crit(err);

        return DEFAULT_IMAGE;
    }
};


module.exports = self;