var SDT = artifacts.require("./SDT.sol");
var Factory = artifacts.require("./Factory.sol");
var Profile = artifacts.require("./Profile.sol");
//var HP = artifacts.require("./HubProfile.sol");
var FactoryH = artifacts.require("./FactoryH.sol");
var FactoryC = artifacts.require("./FactoryC.sol");
var Network = artifacts.require("./Network.sol");
var creator = artifacts.require("./creator.sol");

module.exports = function(deployer) {

  deployer.deploy(SDT).then(function() {
    return deployer.deploy(FactoryH);
  }).then(function () {
    return deployer.deploy(FactoryC);
  }).then(function () {
      return deployer.deploy(Factory, SDT.address, FactoryH.address, FactoryC.address);
  }).then(function () {
      return deployer.deploy(Network,Factory.address);
  }).then(function () {
      return deployer.deploy(creator);
  }).then(function () {
      return deployer.deploy(Profile,0x0,0x0,0x0,true);
  });
};
