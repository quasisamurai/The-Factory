pragma solidity ^0.4.14;

import './Profile.sol';

contract FactoryH {

  event LogCr(address owner);

  function createH(address _profileowner, address dao, address Sonm, address sharesTokenAddress) public returns (address) {
    bool isHub = true;
    //LogCr(_profileowner);
    return address(new Profile(_profileowner, dao, Sonm, sharesTokenAddress, isHub));
  }

}
