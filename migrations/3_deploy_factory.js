var SDT = artifacts.require("./SDT.sol");
var Factory = artifacts.require("./Factory.sol");
var FactoryH = artifacts.require("./FactoryH.sol");
var FactoryC = artifacts.require("./FactoryC.sol");

module.exports = function(deployer) {
   deployer.deploy(Factory, SDT.address, FactoryH.address, FactoryC.address);
};
