var SDT = artifacts.require("./SDT.sol");
var Factory = artifacts.require("./Factory.sol");

module.exports = function(deployer) {

    deployer.deploy(SDT).then(function () {
        return deployer.deploy(Factory, web3.eth.accounts[0]);
    });

};
//web3.eth.accounts[0]
