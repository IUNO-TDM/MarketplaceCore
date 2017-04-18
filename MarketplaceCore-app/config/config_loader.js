/**
 * Created by beuttlerma on 18.04.17.
 */

var self = {};

/**
 * To use a custom config file use the config_default as a template.
 * Save the custom config file in the same directory. All files starting with private* will be ignored by git.
 *
 * Set the file name as environment variable for TDM_CORE_CONFIG.
 *
 * If the custom config is missing any variables, the default variables will be used.
 * If no custom config is defined, the default configuration will be loaded.
 *
 * @returns {config}
 */

var config;

self.loadConfig = function () {
    if (!config) {
        var defaultConfig = require('./config_defaults');

        if (process.env['TDM_CORE_CONFIG']) {
            console.info('Loading configuration file: ' + process.env['TDM_CORE_CONFIG']);

            var customConfig = require('./' + process.env['TDM_CORE_CONFIG']);

            // override default values from custom configuration
            for (var key in customConfig) {
                defaultConfig[key] = customConfig[key];
            }
        }
        else {
            console.warn('ENV Variable: TDM_CORE_CONFIG not specified. Loading defaults only.');
        }
        config = defaultConfig;
    }


    return config;
};

module.exports = self;