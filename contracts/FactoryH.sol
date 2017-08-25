pragma solidity ^0.4.11;


//Raw prototype of Profile factory


//TODO - DOCS


import './HubProfile.sol';
//import './MinerProfile.sol';
//import './Declaration.sol';

contract FactoryH {

  event LogCr(address owner);

  function createH(address _hubowner, address dao, network Sonm, token sharesTokenAddress, bool _privat) public returns (address) {
    return address(new HubProfile(_hubowner, dao, Sonm, sharesTokenAddress,_privat));
  //  return address(hp.Reproduce(_hubowner, dao, Sonm, sharesTokenAddress,_privat));

      LogCr(_hubowner);
  }

}
