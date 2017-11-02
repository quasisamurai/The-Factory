var Factory = artifacts.require("./Factory.sol");
var Network = artifacts.require("./Network.sol");

module.exports = function (deployer) {
  deployer.deploy(Network, Factory.address);
};
