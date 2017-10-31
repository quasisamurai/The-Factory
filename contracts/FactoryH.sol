pragma solidity ^0.4.13;

import './Profile.sol';

contract FactoryH {

  event LogCr(address owner);
  event Acceptance2(address owner, address dao, address Sonm, address token, bool isHub);

  function createH(address _profileowner, address dao, address Sonm, address sharesTokenAddress) public returns (address) {
    bool isHub = true;
    LogCr(_profileowner);
    Acceptance2(_profileowner,dao,Sonm,sharesTokenAddress,isHub);
  //  return address(new Profile(_profileowner, dao, Sonm, sharesTokenAddress, isHub));
    address fish = 0x0;
    return fish;
  }

}
