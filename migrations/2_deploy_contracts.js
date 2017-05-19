var ConvertLib = artifacts.require("./ConvertLib.sol");
var MetaCoin = artifacts.require("./MetaCoin.sol");



var Token = artifacts.require("./SDT.sol");
var Factory = artifacts.require("./Hubs&Miners/Factory.sol");
var Whitelist = artifacts.require("./Whitelist/Whitelist.sol");

module.exports = function(deployer) {

  deployer.deploy(Token).then(function () {
    return deployer.deploy(Factory, Token.address, web3.eth.accounts[0]);
  }).then( function () {
      return deployer.deploy(Whitelist, Factory.address);
  });

};
