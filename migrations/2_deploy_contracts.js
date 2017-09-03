var SDT = artifacts.require("./SDT.sol");
var Factory = artifacts.require("./Factory.sol");
var Profile = artifacts.require("./Profile.sol");
//var HP = artifacts.require("./HubProfile.sol");
var FactoryH = artifacts.require("./FactoryH.sol");
var FactoryM = artifacts.require("./FactoryM.sol");
var FactoryC = artifacts.require("./FactoryC.sol");
var Network = artifacts.require("./Network.sol");

module.exports = function(deployer) {

  deployer.deploy(SDT).then(function() {
    return deployer.deploy(FactoryH);
  }).then(function () {
    return deployer.deploy(FactoryM);
  }).then(function () {
    return deployer.deploy(FactoryC);
  }).then(function () {
<<<<<<< HEAD
      return deployer.deploy(Factory, SDT.address, FactoryH.address, FactoryM.address, FactoryC.address);
=======
      return deployer.deploy(Factory, SDT.address, web3.eth.accounts[0], FactoryH.address, FactoryM.address, FactoryC.address, SDT.address, FactoryH.address, FactoryM.address, FactoryC.address);
>>>>>>> a99337b110b33f0999220e70cf02bee2a91efada
  }).then(function () {
      return deployer.deploy(Network,Factory.address, SDT.address, FactoryH.address, FactoryM.address, FactoryC.address, Factory.address);
});




};
