pragma solidity ^0.4.8;

//Whitelist prototype

//TODO: README
//TODO: Phase renewal in struct.
//TODO: Approved (whited) wallets mapping

contract factory{
  mapping (address => bool) public hubs;
  mapping (address => bool) public miners;
  function check(address _hubwallet) public returns(bool);
  function checkM(address _minwallet) public returns(bool);
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
  event RegistredMiner(address indexed _owner,address indexed wallet, uint64 indexed time);


  function Whitelist(factory Factory){

    WalletsFactory = factory(Factory);

  }

  function RegisterHub(address _owner, address wallet, uint64 time) public returns(bool) {

    

    address owner = WalletsFactory.HownerOf(msg.sender);
    if (owner!=_owner) throw;

    Info info = Registred[wallet];
    info.owner=_owner;
    //Time is money!
    info.RegTime=time;

    RegistredHub(_owner,wallet,time);
    return true;

  }

  function RegisterMin(address _owner, address wallet, uint64 time) public returns(bool) {



    address owner = WalletsFactory.MownerOf(msg.sender);
    if (owner!=_owner) throw;

    Info info = Registred[wallet];
    info.owner=_owner;
    //Time is money!
    info.RegTime=time;

    RegistredHub(_owner,wallet,time);
    return true;

  }

}
