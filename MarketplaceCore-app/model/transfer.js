/**
 * Created by beuttlerma on 13.04.17.
 */

function Transfer(address, coin) {
    this.address = address;
    this.coin = coin;
}


Transfer.prototype.CreateListFromJSON = function (jsonData) {
    var transfers = [];
    for (var key in jsonData) {
        transfers.push(this.CreateFromJSON(jsonData['key']));
    }
};

Transfer.prototype.CreateFromJSON = function (jsonData) {
    return new Transfer(jsonData['address'], jsonData['coin']);
};
module.exports = Transfer;