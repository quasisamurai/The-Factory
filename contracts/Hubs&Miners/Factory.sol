pragma solidity ^0.4.8;


//Raw prototype of wallet factory


//TODO - README



import './HubWallet.sol';
import './MinerWallet.sol';


contract Factory {


  token sharesTokenAddress;
  address dao;
  whitelist Whitelist;

// wallet => owner
  mapping (address => address) public hubs;
  mapping (address => address) public miners;

  function Factory(token TokenAddress,address _dao, whitelist _whitelist){

    sharesTokenAddress = TokenAddress;
    dao=_dao;
    Whitelist= whitelist(_whitelist);

  }

  modifier onlyDao()     { if(msg.sender != dao) throw; _; }

  function changeAdresses(address _dao, whitelist _whitelist) public onlyDao{
    dao=_dao;
    Whitelist=whitelist(_whitelist);

  }

  function createHub() public returns(address) {
    address _hubowner = msg.sender;
    address hubwallet = create(_hubowner);
    hubs[hubwallet]= _hubowner;


  }

  function createMiner() public returns(address) {
    address _minowner = msg.sender;
    address minwallet = createM(_minowner);
    miners[minwallet]= _minowner;

  }

  function create(address _hubowner) private returns(address) {
    return address(new HubWallet(_hubowner,dao,Whitelist,sharesTokenAddress));
  }

  function createM(address _minowner) private returns(address) {
    return address(new MinerWallet(_minowner,dao,Whitelist,sharesTokenAddress));
  }


/*
  function check(address _hubwallet) public returns(bool){
    if(hubs[_hubwallet]=true)
    return true;
  }

  function checkM(address _minwallet) public returns(bool){
    if(miners[_minwallet]=true)
    return true;
  }
*/

function HownerOf(address _wallet) constant returns (address _owner) {
  return hubs[_wallet];
}

function MownerOf(address _wallet) constant returns (address _owner) {
  return miners[_wallet];
}

}
