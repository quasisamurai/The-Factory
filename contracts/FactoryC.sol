pragma solidity ^0.4.14;

import './Profile.sol';

contract FactoryC {

  event LogCr(address owner);

  function createC(address _profileowner, address dao, address Sonm, address sharesTokenAddress) public returns (address) {
    bool isHub = false;
    //LogCr(_profileowner);
    return address(new Profile(_profileowner, dao, Sonm, sharesTokenAddress, isHub));
    }

  }
