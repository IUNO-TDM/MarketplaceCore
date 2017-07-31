/**
 * Created by beuttlerma on 13.04.17.
 */

/**
 *
 * @param address
 * @param coin
 * @constructor
 */
function Transfer(address, coin) {
    this.address = address;
    this.coin = coin;
}


Transfer.prototype.CreateListFromJSON = Transfer.CreateListFromJSON = function (jsonData) {
    if (!jsonData) {
        return [];
    }

    var transfers = [];
    for (var key in jsonData) {
        transfers.push(this.CreateFromJSON(jsonData[key]));
    }

    return transfers;
};

Transfer.prototype.CreateFromJSON = Transfer.CreateFromJSON = function (jsonData) {
    if (!jsonData) {
        return new Transfer();
    }
    return new Transfer(jsonData['address'], jsonData['coin']);
};

module.exports = Transfer;