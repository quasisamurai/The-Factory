pragma solidity ^0.4.8;

import './HubWallet.sol';

contract HubFactory {


  address sharesTokenAddress;
  address dao;
  address whitelist;

  function HubFactory(address TokenAddress,address _dao, address _whitelist){

    sharesTokenAddress = TokenAddress;
    dao=_dao;
    whitelist=_whitelist;

  }

  modifier onlyDao()     { if(msg.sender != dao) throw; _; }

  function changeAdresses(address _dao, address _whitelist) public onlyDao{
    dao=_dao;
    whitelist=_whitelist;

  }


  function create(address _hubowner) public returns(address) {
    return address(new HubWallet(_hubowner,dao,whitelist,sharesTokenAddress));
  }
}
