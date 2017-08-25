pragma solidity ^0.4.11;


//Raw prototype of Profile factory


//TODO - DOCS


//import './HubProfile.sol';
import './MinerProfile.sol';
//import './Declaration.sol';

contract FactoryM {

  event LogCr(address owner);

  function createM(address _minowner, address dao, network Sonm, token sharesTokenAddress) public returns (address) {
    return address(new MinerProfile(_minowner, dao, Sonm, sharesTokenAddress));


      LogCr(_minowner);
  }

}
