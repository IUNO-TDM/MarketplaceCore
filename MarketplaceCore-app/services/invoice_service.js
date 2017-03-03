/**
 * Created by beuttlerma on 03.03.17.
 */

var self = {};

//TODO: Remove this function
function getRandomIntInclusive(min, max) {
    min = Math.ceil(min);
    max = Math.floor(max);
    return Math.floor(Math.random() * (max - min + 1)) + min;
}

self.generateInvoiceForRequest = function (request, callback) {

    var invoice = {
        expiration: new Date(new Date().getTime() + (2 * 60 * 60 * 1000)).toISOString(),
        transfers: [
            {
                address: 'my1vtAh3gTZEPVmF7TGzzfmsf2wcTVaYUj',
                coin: getRandomIntInclusive(1, 1000000)
            },
            {
                address: '1FQ7LNa74kpimsb1g8s5gbG6P67yHb8njj',
                coin: getRandomIntInclusive(1, 1000000)
            }
        ]
    };


    callback(null, invoice);
};


module.exports = self;