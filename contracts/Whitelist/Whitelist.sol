pragma solidity ^0.4.8;

//Whitelist prototype

contract factory{
  mapping (address => bool) public hubs;
  function check(address _hubwallet) public returns(bool);
}


contract Whitelist{

  factory HubWalletsFactory;




  event RegistredHub(address indexed _owner,address indexed wallet, uint64 indexed time);


  function Whitelist(factory HubFactory){

    HubWalletsFactory = factory(HubFactory);

  }

  Register(address _owner, address wallet, uint64 time){

    bool checked = HubWalletsFactory.check(wallet);
    if (checked!=true) throw;
    RegistredHub(_owner,wallet,time);

  }


}
