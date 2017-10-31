var SDT = artifacts.require("./SDT.sol");
var FactoryH = artifacts.require("./FactoryH.sol");
var FactoryC = artifacts.require("./FactoryC.sol");

module.exports = function(deployer) {
  deployer.deploy(SDT);
  deployer.deploy(FactoryH);
  deployer.deploy(FactoryC);
};
