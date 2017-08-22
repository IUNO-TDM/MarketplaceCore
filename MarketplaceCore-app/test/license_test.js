var licenseCentral = require('../adapter/license_central_adapter');


const cmSerial = '3-4019155';
const customerId = 1234;
const productCode = 10;
const itemId = 'pc' + productCode;
const itemName = 'Test9911';
const quantity = 1;



licenseCentral.createItem(itemId, itemName, productCode, function(err, success) {
    if (err) {
        console.error(err);
    }
    console.log('Create Item: ' + success);

    licenseCentral.createAndActivateLicense(cmSerial, customerId, itemId, quantity, function (err, success) {
        if (err) {
            console.error(err);
        }
        console.log('ActivateLicense: ' + success);
    });
});


// There are no activatable licenses assigned for CmContainer with serial  ID 3-4019155
// Cannot create update from an old CmActLicense context