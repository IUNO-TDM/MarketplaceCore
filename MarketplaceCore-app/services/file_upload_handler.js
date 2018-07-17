const multer = require('multer');
const uuid = require('uuid/v4');
const CONFIG = require('../config/config_loader');

const storage = multer.diskStorage({
    destination: function (req, file, callback) {
        callback(null, CONFIG.TMP_DIR)
    },
    filename: function (req, file, callback) {
        callback(null, uuid() + '.gz');
    }
});

const filter = function (req, file, cb) {
    logger.debug(file);

    if (!file) {
        return cb(null, false);
    }
    if (file.fieldname !== 'file') {
        logger.warn('[content_filter] upload attempt with wrong field name');
        return cb(new Error('Wrong field name for technology data upload'), false);
    }
    // Check if oritinalname is an uuid
    if (!(/^[A-F\d]{8}-[A-F\d]{4}-4[A-F\d]{3}-[89AB][A-F\d]{3}-[A-F\d]{12}.gz$/i.test(file.originalname))) {
        logger.warn('[content_filter] upload attempt with wrong original name');
        return cb(new Error('Wrong file name for technology data upload'), false);
    }
    if (file.encoding !== 'base64') {
        logger.warn('[content_filter] upload attempt with wrong encoding');
        return cb(new Error('Wrong transport encoding for technology data upload'), false);
    }
    if (file.mimetype !== 'application/gzip') {
        logger.warn('[content_filter] upload attempt with wrong mime type');
        return cb(new Error('Wrong mime-type for technology data upload'), false);
    }

    cb(null, true);
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