const logger = require('../global/logger');
const nodemailer = require('nodemailer');
const CONFIG = require('../config/config_loader');
const fs = require('fs');
const path = require('path');

const self = {};

self.sendReportToAdmins = function (title, message) {
    if (!title || !message) {
        return;
    }

    if (CONFIG.REPORT_EMAIL_ADRESSES.length <= 0) {
        logger.info('[email_service] No report targets specified. No email will be send');

        return
    }

    if (process.env.NODE_ENV === 'development' || process.env.NODE_ENV === 'docker') {
        logger.info('[email_service] Development Environment - Emails are disabled during development');

        return;
    }

    const transporter = nodemailer.createTransport(CONFIG.SMTP_CONFIG);
    const template = 'assets/mail_templates/admin_report.html';
    const placeHolders = {
        '\\${TITLE}': title,
        '\\${MESSAGE}': message,
    };

    loadHTMLTemplate(template, placeHolders, function (err, template) {
        if (err) {
            logger.warn('[email_service] could not load html template for password reset.');
            return;
        }

        const mailOptions = {
            from: CONFIG.SMTP_CONFIG.email,
            to: CONFIG.REPORT_EMAIL_ADRESSES,
            subject: 'IUNO - Technologiedatenmarktplatz: Admin Report',
            html: template
        };

        transporter.sendMail(mailOptions, function (error, info) {
            if (error) {
                logger.warn(error);
            } else {
                logger.info('[email_service]Email sent: ' + info.response);
            }
        });
    });
};


function loadHTMLTemplate(templateName, placeholders, callback) {

    fs.readFile(path.resolve(templateName), "utf8", function (err, data) {
        if (err) {
            logger.crit(err);
            return callback(err);
        }

        for (let key in placeholders) {
            data = data.replace(new RegExp(key, 'g'), placeholders[key]);
        }

        callback(null, data);
    });
}

module.exports = self;
