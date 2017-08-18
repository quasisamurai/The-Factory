var SDT = artifacts.require("./SDT.sol");
var Factory = artifacts.require("./Factory.sol");

module.exports = function(deployer) {

    deployer.deploy(SDT);
//    deployer.deploy(Factory);

    deployer.deploy(Factory,SDT.address, web3.eth.accounts[0]);


};
//web3.eth.accounts[0]
