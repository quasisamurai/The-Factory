pragma solidity ^0.4.8;


//Raw prototype of hub-wallet factory


//TODO - README



import './HubWallet.sol';
import './MinerWallet.sol';


contract HubFactory {


  token sharesTokenAddress;
  address dao;
  whitelist Whitelist;

  mapping (address => bool) public hubs;
  mapping (address => bool) public miners;

  function HubFactory(token TokenAddress,address _dao, whitelist _whitelist){

    sharesTokenAddress = TokenAddress;
    dao=_dao;
    Whitelist= whitelist(_whitelist);

  }

  modifier onlyDao()     { if(msg.sender != dao) throw; _; }

  function changeAdresses(address _dao, whitelist _whitelist) public onlyDao{
    dao=_dao;
    Whitelist=whitelist(_whitelist);

  }

  function createHub(address _hubowner) public returns(address) {
    address hubwallet = create(_hubowner);
    hubs[hubwallet]= true;

  }

  function createMiner(address _minowner) public returns(address) {
    address minwallet = createM(_minowner);
    miners[minwallet]= true;

  }

  function create(address _hubowner) private returns(address) {
    return address(new HubWallet(_hubowner,dao,Whitelist,sharesTokenAddress));
  }

  function createM(address _minowner) private returns(address) {
    return address(new MinerWallet(_minowner,dao,Whitelist,sharesTokenAddress));
  }

  function check(address _hubwallet) public returns(bool){
    if(hubs[_hubwallet]=true)
    return true;
  }

  function checkM(address _minwallet) public returns(bool){
    if(miners[_minwallet]=true)
    return true;
  }

}
