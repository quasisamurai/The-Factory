var SDT = artifacts.require("./SDT.sol");
var Factory = artifacts.require("./Factory.sol");
var Whitelist = artifacts.require("./Whitelist.sol");

module.exports = function(deployer) {

    deployer.deploy(SDT).then(function () {
        return deployer.deploy(Factory, SDT.address, web3.eth.accounts[0]);
    })
    .then( function () {
        return deployer.deploy(Whitelist, Factory.address);
    });

};
