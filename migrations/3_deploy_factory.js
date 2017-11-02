var SDT = artifacts.require("./SDT.sol");
var Factory = artifacts.require("./Factory.sol");

module.exports = function(deployer) {
   deployer.deploy(Factory, SDT.address, {gas: 6000000});
};
