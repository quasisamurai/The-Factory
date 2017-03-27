pragma solidity ^0.4.8;

//TODO - README



import './HubWallet.sol';

contract HubFactory {


  token sharesTokenAddress;
  address dao;
  address whitelist;

  mapping (address => bool) public hubs;

  function HubFactory(token TokenAddress,address _dao, address _whitelist){

    sharesTokenAddress = TokenAddress;
    dao=_dao;
    whitelist=_whitelist;

  }

  modifier onlyDao()     { if(msg.sender != dao) throw; _; }

  function changeAdresses(address _dao, address _whitelist) public onlyDao{
    dao=_dao;
    whitelist=_whitelist;

  }

  function createHub(address _hubowner) public returns(address) {
    address hubwallet = create(_hubowner);
    hubs[hubwallet]= true;

  }

  function create(address _hubowner) private returns(address) {
    return address(new HubWallet(_hubowner,dao,whitelist,sharesTokenAddress));
  }
}
