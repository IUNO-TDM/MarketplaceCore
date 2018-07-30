const logger = require('../global/logger');

const multer = require('multer');
const uuid = require('uuid/v4');
const fs = require('fs');

const CONFIG = require('../config/config_loader');
const TechnologyData = require('../database/model/technologydata');


if (!fs.existsSync(CONFIG.FILE_DIR)) {
    fs.mkdir(CONFIG.FILE_DIR);
}
if (!fs.existsSync(CONFIG.TMP_DIR)) {
    fs.mkdir(CONFIG.TMP_DIR);
}

const storage = multer.diskStorage({
    destination: function (req, file, callback) {
        callback(null, CONFIG.TMP_DIR)
    },
    filename: function (req, file, callback) {
        callback(null, uuid() + '.gz');
    }
});

const filter = function (req, file, cb) {
    TechnologyData.FindSingle(req.token.user.id, req.token.user.roles, req.params['id'], (err, data) => {

        if (err || !data) {
            logger.warn('[file_upload_handler] attempted upload of content for unknown technology data');
            return cb(err, false)
        }

        if (data.createdby !== req.token.user.id) {
            logger.warn('[file_upload_handler] attempted upload of content for wrong user');
            return cb(null, false)
        }

        if(!data.isfile) {
            logger.warn('[file_upload_handler] trying to upload content file for a none-file entry');
            return cb(null, false)
        }
        
        req.data = data;

        logger.debug(file);

        if (!file) {
            return cb(null, false);
        }
        if (file.fieldname !== 'file') {
            logger.warn('[file_upload_handler] upload attempt with wrong field name');
            return cb(new Error('Wrong field name for technology data upload'), false);
        }
        // Check if original is an uuid
        if (file.originalname !== data.technologydatauuid + '.gz') {
            logger.warn('[file_upload_handler] upload attempt with wrong original name');
            return cb(new Error('Wrong file name for technology data upload'), false);
        }
        // if (file.encoding !== 'base64') {
        //     logger.warn('[file_upload_handler] upload attempt with wrong encoding');
        //     return cb(new Error('Wrong transport encoding for technology data upload'), false);
        // }
        // if (file.mimetype !== 'application/gzip') {
        //     logger.warn('[file_upload_handler] upload attempt with wrong mime type');
        //     return cb(new Error('Wrong mime-type for technology data upload'), false);
        // }

        cb(null, true);
    });
};


const upload = multer({
    storage: storage,
    fileFilter: filter,
    limits: {
        fileSize: 104857600,
        files: 1,
        parts: 1,
        fields: 0,
        headerPairs: 1
    }
});

module.exports = upload.single('file');