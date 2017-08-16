var SDT = artifacts.require("./SDT.sol");
var Factory = artifacts.require("./Factory.sol");

module.exports = function(deployer) {

    deployer.deploy(SDT).then(function () {
        return deployer.deploy(Factory, SDT.address,0x0 );
    });

};
//web3.eth.accounts[0]
