var SDT = artifacts.require("./SDT.sol");
var Factory = artifacts.require("./Factory.sol");
var Profile = artifacts.require("./Profile.sol");
//var HP = artifacts.require("./HubProfile.sol");
var FactoryH = artifacts.require("./FactoryH.sol");
var FactoryM = artifacts.require("./FactoryM.sol");

module.exports = function(deployer) {

  deployer.deploy(SDT).then(function() {
    return deployer.deploy(FactoryH);
  }).then(function () {
  return deployer.deploy(FactoryM);
  }).then(function () {

  return deployer.deploy(Factory, SDT.address, web3.eth.accounts[0], FactoryH.address, FactoryM.address);


});


    //deployer.deploy(Profile);

};
