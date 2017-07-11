// var ConvertLib = artifacts.require("./ConvertLib.sol");
// var MetaCoin = artifacts.require("./MetaCoin.sol");

var SDT = artifacts.require("./SDT.sol");
var Factory = artifacts.require("./Factory.sol");
var Whitelist = artifacts.require("./Whitelist.sol");

console.log(SDT);
console.log(Factory);
console.log(Whitelist);

module.exports = function(deployer) {

    deployer.deploy(SDT).then(function () {
        return deployer.deploy(Factory, SDT.address, web3.eth.accounts[0]);
    })
    .then( function () {
        return deployer.deploy(Whitelist, Factory.address);
    });

};
