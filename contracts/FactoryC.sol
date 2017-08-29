pragma solidity ^0.4.11;

// Alpha prototype of Factory fo client Profiles;


import './ClientProfile.sol';

contract FactoryC {

  event LogCr(address owner);

  function createC(address _clientowner, address dao, network Sonm, token sharesTokenAddress) public returns (address) {
    return address(new ClientProfile(_clientowner, dao, Sonm, sharesTokenAddress));


      LogCr(_clientowner);
    }

  }
