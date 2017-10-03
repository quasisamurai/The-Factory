pragma solidity ^0.4.11;


//Raw prototype of Profile factory


//TODO - DOCS


import './HubProfile.sol';


contract FactoryH {

  event LogCr(address owner);

  function createH(address _hubowner, address dao, network Sonm, token sharesTokenAddress) public returns (address) {
    return address(new HubProfile(_hubowner, dao, Sonm, sharesTokenAddress));
  //  return address(hp.Reproduce(_hubowner, dao, Sonm, sharesTokenAddress));

      LogCr(_hubowner);
  }

}
