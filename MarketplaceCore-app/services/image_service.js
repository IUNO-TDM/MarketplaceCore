const fs = require('fs');
const path = require('path');
const config = require('../config/config_loader');
const logger = require('../global/logger');
const seedRandom = require('seedrandom');
const crypto = require('crypto');

const mime = require('mime-types');

const self = {};

function randomInt(low, high, seed) {
    if (seed) {
        return Math.floor(seedRandom(seed)() * (high - low) + low);
    }
    else {
        return Math.floor(Math.random() * (high - low) + low);
    }
}


self.getRandomImagePath = function () {
    try {
        const files = fs.readdirSync(config.IMAGE_DIR);

        const randomIndex = randomInt(0, files.length);

        return path.join(config.IMAGE_DIR, files[randomIndex]);
    }
    catch (err) {
        logger.crit(err);

        return config.DEFAULT_IMAGE;
    }
};

self.getDefaultImagePathForUUID = function (uuid) {
    try {
        const files = fs.readdirSync(config.IMAGE_DIR);

        const randomIndex = randomInt(0, files.length, uuid);

        return path.join(config.IMAGE_DIR, files[randomIndex]);
    }
    catch (err) {
        logger.crit(err);

        return config.DEFAULT_IMAGE;
    }
};

self.saveImage = function (user, tdName, image, mimeType) {
    const hash = crypto.createHash('md5').update(user + tdName).digest('hex');
    const extension = mime.extension(mimeType);
    const imageName = `${hash}.${extension}`;

    const filePath = path.join(config.IMAGE_DIR, imageName);

    fs.writeFile(filePath, image, (err) => {
        if (err) {
            logger.crit(err);
        }
    });

    return config.IMAGE_DIR + imageName;
};


module.exports = self;