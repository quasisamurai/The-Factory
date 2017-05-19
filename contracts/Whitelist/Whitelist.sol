pragma solidity ^0.4.8;

//Whitelist prototype

//TODO: README
//TODO: Phase renewal in struct.
//TODO: Approved (whited) wallets mapping

contract factory{
  mapping (address => bool) public hubs;
  function check(address _hubwallet) public returns(bool);
}


contract Whitelist{

  factory WalletsFactory;

  struct Info {

    address owner;
    uint64 RegTime;

    // Probably we need to register and renew Phase of wallet as well.

  }

  mapping (address => Info) public Registred;


  event RegistredHub(address indexed _owner,address indexed wallet, uint64 indexed time);


  function Whitelist(factory Factory){

    WalletsFactory = factory(Factory);

  }

  function Register(address _owner, address wallet, uint64 time) public returns(bool) {

    bool checked = WalletsFactory.check(wallet);
    if (checked!=true) throw;

    Info info = Registred[wallet];
    info.owner=_owner;
    //Time is money!
    info.RegTime=time;

    RegistredHub(_owner,wallet,time);
    return true;

  }


}
